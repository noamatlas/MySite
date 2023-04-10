--SQL Script for Brosh-Group
--By Noam Atlas 050-5576278
--beginning on 2023-01-22
--SHLAV-B of SQL Project
-----------------------------------------
--SHLAV-B 005 Continue Z: Z2
-----------------------------------------

CREATE TYPE dbo.StructForCalc AS table
(
 asm int NOT NULL PRIMARY KEY CLUSTERED,
 sug nvarchar(3) NOT NULL,
 patur bit DEFAULT (0) NOT NULL,
 tarich datetime NULL,
 sumLines decimal(25,13) NULL,
 ahuz1 decimal(25,13) NULL,
 ahuz2 decimal(25,13) NULL,
 yadani decimal(25,13) NULL
)
GO

CREATE OR ALTER PROC [sps].[usp_MultiCalcAllNow] (@dataStruct dbo.StructForCalc READONLY)
	--(@patur bit = 0, @kotSug nvarchar(3), @kotTarich datetime, @kotShumShurot decimal(25,13), @kotAhuz1 decimal(25,13),
	-- @kotAhuz2 decimal(25,13), @SumYadani decimal(25,13))
	-- USE @dataStruct instead. It's a table!
AS BEGIN
	DECLARE @sugIgul tinyint , @maamRate decimal(25,13), @newkotSchum1 decimal(25,13), @afterDiscount1 decimal(25,13);
	DECLARE @newkotSchum2 decimal(25,13), @afterDiscount2 decimal(25,13), @newkotMaam decimal(25,13);
	DECLARE @newkotTotal decimal(25,13), @useYadaniAsTotal bit = 0, @tempTotal decimal(25,13), @newkotAhuz1 decimal(25,13);
	DECLARE @i int, @maxId int, @globalMaamRate decimal(25,13), @howManySeperateDates int, @aDate datetime;
	--these are for temporary "current" values to play with:
	DECLARE @currAsm int, @patur bit = 0, @kotSug nvarchar(3), @kotTarich datetime, @kotShumShurot decimal(25,13), @kotAhuz1 decimal(25,13), @kotAhuz2 decimal(25,13), @SumYadani decimal(25,13)

	SET XACT_ABORT, NOCOUNT ON
	BEGIN TRY
		--check if there is something to work on
		IF NOT EXISTS(SELECT * FROM @dataStruct WHERE asm IS NOT NULL)
			BEGIN
				SELECT NULL AS asm, NULL AS schumShurot, NULL AS newkotSchum1, NULL AS newkotSchum2, NULL AS newkotMaam, NULL AS newkotTotal, NULL AS ahuz1IfYadani;
				RETURN;
			END;
		SELECT @maxId = COUNT(*) FROM @dataStruct;
		--temp table for keeping data from @dataStruct
		IF OBJECT_ID('tempdb..#struct') IS NOT NULL
			DROP TABLE #struct;
		CREATE TABLE #struct
		(id int NOT NULL PRIMARY KEY, asm int NOT NULL UNIQUE, sug nvarchar(3) NOT NULL, patur bit DEFAULT (0) NOT NULL,
		 tarich datetime NULL, sumLines decimal(25,13) NULL, ahuz1 decimal(25,13) NULL, ahuz2 decimal(25,13) NULL, yadani decimal(25,13) NULL);
		--temp table for keeping the "answers"
		IF OBJECT_ID('tempdb..#Answers') IS NOT NULL
			DROP TABLE #Answers;
		CREATE TABLE #Answers 
		(asm int NOT NULL PRIMARY KEY, schumShurot decimal(25,13), newkotSchum1 decimal(25,13), 
		 newkotSchum2 decimal(25,13), newkotMaam decimal(25,13), newkotTotal decimal(25,13), ahuz1IfYadani decimal(25,13));
		 
		 --copy data from @dataStruct to #struct:
		 INSERT INTO #struct (id, asm, sug, patur, tarich, sumLines, ahuz1, ahuz2, yadani)
			SELECT ROW_NUMBER() OVER(ORDER BY asm) AS theId, * FROM @dataStruct ORDER BY asm;

		SET @globalMaamRate = NULL;
		IF [sps].[fnCompanyCollectsMaam]() = 0
			UPDATE #struct SET [patur] = 1; --added 22.3.23 All of them.
		ELSE
			BEGIN --29.3.23	
				WITH CTEdates AS
				(SELECT [tarich] FROM #struct WHERE id IS NOT NULL GROUP BY [tarich])
				SELECT @howManySeperateDates = COUNT(*) FROM CTEdates;
				IF @howManySeperateDates = 1
					BEGIN
						SELECT TOP (1) @aDate = [tarich] FROM #struct WHERE id IS NOT NULL;
						SELECT @globalMaamRate = [sps].[fnFindMaam](ISNULL(@aDate, GETDATE()));
					END;
			END;

		SELECT @maxId = MAX(id) FROM #struct;
		--start a while loop
		SET @i = 1;
		WHILE @i <= @maxId
			BEGIN
				--take one row from #struct - to variables
				SELECT @currAsm = [asm], @patur = [patur], @kotSug = [sug], @kotTarich = [tarich], @kotShumShurot = [sumLines], @kotAhuz1 = [ahuz1], @kotAhuz2 = [ahuz2], @SumYadani = [yadani]
					FROM #struct WHERE id = @i;

				--set @sugIgul - sug igul: 1 = round to tenths of sheqels. 2 = round to half. 3 = round to shalem. else = don't round.
				SELECT @sugIgul = ISNULL([sgmIgul], 0) FROM [dbo].[T02Sugim] WITH (NOLOCK) WHERE [sgmSugMismach] = @kotSug;
				
				--maam rate
				IF @patur = 1
					SET @maamRate = 0;
				ELSE
					IF @howManySeperateDates = 1
						SET @maamRate = @globalMaamRate;
					ELSE
						SELECT @maamRate = [sps].[fnFindMaam](ISNULL(@kotTarich, GETDATE()));

				--calc @newkotSchum1 & @afterDiscount1
				IF ISNULL(@kotAhuz1, 0) = 0
					SET @newkotSchum1 = 0
				ELSE
					SET @newkotSchum1 = ROUND(CONVERT(decimal(25,13), (@kotShumShurot * @kotAhuz1 / CONVERT(decimal(25,13), 100))), 2);
				SET @afterDiscount1 = @kotShumShurot - @newkotSchum1;
				--again with discount 2
				IF ISNULL(@kotAhuz2, 0) = 0
					SET @newkotSchum2 = 0
				ELSE
					SET @newkotSchum2 = ROUND(CONVERT(decimal(25,13), (@afterDiscount1 * @kotAhuz2 / CONVERT(decimal(25,13), 100))), 2);
				SET @afterDiscount2 = @afterDiscount1 - @newkotSchum2;

				--calc @newkotMaam
				IF @maamRate = 0
					SET @newkotMaam = 0
				ELSE
					SET @newkotMaam = ROUND(CONVERT(decimal(25,13), (@afterDiscount2 * @maamRate / CONVERT(decimal(25,13), 100))), 2);
				
				--@newkotTotal
				SET @newkotTotal = @afterDiscount2 + @newkotMaam;

				--but deal with @SumYadani:
				IF ISNULL(@SumYadani, 0) <> 0
					BEGIN
						SET @useYadaniAsTotal = 1;
						SET @newkotTotal = ROUND(@SumYadani, 2);
					END;

				--take care of rounding in T02Sugim
				--@tempTotal
				IF @sugIgul BETWEEN 1 AND 3
					BEGIN
						SET @tempTotal =	CASE	WHEN @sugIgul = 1 THEN ROUND(@newkotTotal, 1)
													WHEN @sugIgul = 2 THEN ROUND(@newkotTotal * CONVERT(decimal(25,13), 2), 0) / CONVERT(decimal(25,13), 2)
													WHEN @sugIgul = 3 THEN ROUND(@newkotTotal, 0)
											END;
						SET @newkotTotal = @tempTotal;
						IF @maamRate <> 0
							SET @newkotMaam = ROUND(CONVERT(decimal(25,13), (@newkotTotal * @maamRate / (@maamRate + CONVERT(decimal(25,13), 100)))), 2);
						SET @newkotSchum1 = @kotShumShurot - (@newkotTotal - @newkotMaam + @newkotSchum2);
					END;
				ELSE
					--calc by @SumYadani			
					IF @useYadaniAsTotal = 1
						BEGIN
							IF @maamRate <> 0
								SET @newkotMaam = ROUND(CONVERT(decimal(25,13), (@newkotTotal * @maamRate / (@maamRate + CONVERT(decimal(25,13), 100)))), 2);
							SET @newkotSchum1 = @kotShumShurot - (@newkotTotal - @newkotMaam + @newkotSchum2);
							SET @newkotAhuz1 = ROUND(CONVERT(decimal(25,13), (@newkotSchum1 * CONVERT(decimal(25,13), 100) / @kotShumShurot)), 2);
						END;
				----return table with values for document's-koteret:
				--SELECT	ISNULL(@newkotSchum1, 0) AS 'newkotSchum1', ISNULL(@newkotSchum2, 0) AS 'newkotSchum2', 
				--		ISNULL(@newkotMaam, 0) AS 'newkotMaam', ISNULL(@newkotTotal, 0) AS 'newkotTotal', @newkotAhuz1 AS 'ahuz1IfYadani';

				--insert current answers into #Answers
				INSERT INTO #Answers (asm, schumShurot, newkotSchum1, newkotSchum2, newkotMaam, newkotTotal, ahuz1IfYadani)
					SELECT @currAsm, @kotShumShurot, ISNULL(@newkotSchum1, 0) AS 'newkotSchum1', ISNULL(@newkotSchum2, 0) AS 'newkotSchum2',
							ISNULL(@newkotMaam, 0) AS 'newkotMaam', ISNULL(@newkotTotal, 0) AS 'newkotTotal', @newkotAhuz1 AS 'ahuz1IfYadani';

				--advance value of @i:
				SET @i = (@i + 1);
			END
			--"return" table #Answers:
			SELECT * FROM #Answers;
	END TRY
	BEGIN CATCH
		SELECT NULL AS asm, NULL AS schumShurot, NULL AS newkotSchum1, NULL AS newkotSchum2, NULL AS newkotMaam, NULL AS newkotTotal, NULL AS ahuz1IfYadani;
		INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes]) VALUES (DB_NAME() + '.' + OBJECT_NAME(@@PROCID), 'Error ' + CONVERT(nvarchar(25), ERROR_NUMBER()) + ' At Line ' + CONVERT(nvarchar(25), ERROR_LINE()), ERROR_MESSAGE());
	END CATCH
END;
GO

ALTER PROC [sps].[usp_SelectBunchNewNumbers] (@kotSug nvarchar(3), @amount int)
AS BEGIN
	DECLARE @lastAsmFromSugim int, @gadolForward int;
	SET XACT_ABORT, NOCOUNT ON;

	IF @kotSug IS NULL OR ISNULL(@amount, 0) < 1
		BEGIN
			SELECT CONVERT(int, NULL) AS docNumbers;
			RETURN;
		END
	IF NOT EXISTS(SELECT * FROM dbo.T02Sugim WHERE sgmSugMismach = @kotSug)
		BEGIN
			SELECT CONVERT(int, NULL) AS docNumbers;
			RETURN;
		END

	BEGIN TRY
			IF OBJECT_ID('tempdb..#Nums') IS NOT NULL
				DROP TABLE #Nums;
			CREATE TABLE #Nums (Num int NOT NULL);			
			ALTER TABLE #Nums ADD CONSTRAINT [Nums$PK] PRIMARY KEY ([Num]);

			--find @lastAsmFromSugim:
			SELECT @lastAsmFromSugim = ISNULL(sgmLast, ISNULL(sgmStarter, 1)) 
				FROM dbo.T02Sugim 
				WHERE sgmSugMismach = @kotSug;

			--populating #Nums with ASm available numbers until @amount:
			WITH kotsJustSug AS
			(
			 SELECT kotASm
			 FROM [dbo].[T02Kotrot] WITH (NOLOCK)
			 WHERE kotSug = @kotSug
			),
			CTENums AS
			(
			 SELECT @lastAsmFromSugim AS theNum
			 UNION ALL
			 SELECT theNum + 1 FROM CTENums WHERE theNum <= (@lastAsmFromSugim + @amount * 10)
			)
			INSERT INTO #Nums (Num)
				SELECT TOP (@amount) CTENums.theNum 
					FROM CTENums LEFT JOIN kotsJustSug ON kotsJustSug.kotASm = CTENums.theNum
					WHERE kotsJustSug.kotASm IS NULL
					ORDER BY CTENums.theNum
					OPTION(MAXRECURSION 0);
	
		IF @kotSug = N'prt'
			BEGIN
				--IF NOT EXISTS(SELECT * FROM [dbo].[T02katParitim] WHERE [katMisparParit] = CONVERT(nvarchar(25), @lastAsmFromSugim))
				--	RETURN @lastAsmFromSugim;

				--SELECT TOP(1) @gadolForward = TRY_CONVERT(int, [katMisparParit]) --ALWAYS exists because ([katMisparParit] EXISTS IN THIS SCOPE AND = @lastAsmFromSugim)
				--	FROM [dbo].[T02katParitim] T1
				--	WHERE ISNUMERIC([katMisparParit]) = 1
				--	AND NOT EXISTS(SELECT * FROM [dbo].[T02katParitim] T2 WHERE TRY_CONVERT(int, T2.[katMisparParit]) = TRY_CONVERT(int, (T1.[katMisparParit] + 1))) 
				--		AND TRY_CONVERT(int, T1.[katMisparParit]) >= @lastAsmFromSugim 
				--	ORDER BY TRY_CONVERT(int, T1.[katMisparParit]);
				SELECT CONVERT(int, NULL) AS docNumbers;
			END
		ELSE
			BEGIN
				SELECT Num AS 'docNumbers' FROM #Nums;
			END		
	END TRY
	BEGIN CATCH		
		INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes])
			VALUES (DB_NAME() + '.' + OBJECT_NAME(@@PROCID), 'Error ' + CONVERT(nvarchar(25), ERROR_NUMBER()) + ' At Line ' + CONVERT(nvarchar(25), ERROR_LINE()), ERROR_MESSAGE());
		SELECT CONVERT(int, NULL) AS docNumbers;
	END CATCH
END
GO
--EXEC [sps].[usp_SelectBunchNewNumbers] @kotSug, @Amount
--GO

CREATE OR ALTER PROC [sps].[usp_MakeTMsByHazKots] (@jsonHazsNums nvarchar(MAX), @dateTM datetime, @txt_Heara nvarchar(MAX), @ovedName nvarchar(20))
AS
BEGIN
	DECLARE @shlav varchar(90), @RetVal int, @RetErrNum int, @RetErrMsg nvarchar(4000);
	DECLARE @finalTmDate datetime, @prt1 tinyint, @prt2 tinyint, @prt3 tinyint, @mll1 tinyint, @mll2 tinyint, @doShonim bit = 0;
	DECLARE @doWriteMaakav bit = 0, @UpdateKodMazav bit = 0, @FoundWrong int, @kotSug nvarchar(3) = N'תמ', @Amount int, @tmpAmount int, @MuzmanToToday bit;
	DECLARE @bunch dbo.StructForCalc, @TeethWordHeb nvarchar(20) = N' - שיניים: ', @TeethWordEng nvarchar(20) = N' - Teeth: ', @doCloseErpSh bit = 0;

	SET XACT_ABORT, NOCOUNT ON;
	SELECT @RetVal = (-2), @RetErrNum = NULL, @RetErrMsg = NULL;

	SET @shlav = 'check argument';
	IF LEN(ISNULL(@jsonHazsNums,'')) = 0
		BEGIN
			SET @RetErrNum = 666;			
			SET @RetErrMsg = N'חסר/ות הזמנה/ות מקור ליצירת תמ.';
			SELECT CONVERT(int, NULL) AS nothingHere;
			SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
			RETURN;
		END;
		SET @shlav = 'check JSON KOT valid';
		IF ISJSON(@jsonHazsNums) = 0
			BEGIN
				SET @RetErrNum = 666;				
				SET @RetErrMsg = N'דאטה לא חוקי להזנת כותרת תמ.';
				SELECT CONVERT(int, NULL) AS nothingHere;
				SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
				RETURN;
			END;
		
		BEGIN TRY
			SET @shlav = 'temp table for the calculations';
			IF OBJECT_ID('tempdb..#CalcAnswers') IS NOT NULL
				DROP TABLE #CalcAnswers;
			CREATE TABLE #CalcAnswers 
			(asm int NOT NULL PRIMARY KEY, schumShurot decimal(25,13), newkotSchum1 decimal(25,13), 
			 newkotSchum2 decimal(25,13), newkotMaam decimal(25,13), newkotTotal decimal(25,13), ahuz1IfYadani decimal(25,13));

			SET @shlav = 'prepare temp table for new ASMs';
			IF OBJECT_ID('tempdb..#TmpNewASMs') IS NOT NULL
				DROP TABLE #TmpNewASMs;
			CREATE TABLE #TmpNewASMs (Asm int NOT NULL);
			ALTER TABLE #TmpNewASMs ADD CONSTRAINT [TmpNewASMs$PK] PRIMARY KEY ([Asm]);

			SET @shlav = 'prepare temp table PreTmKot';
			IF OBJECT_ID('tempdb..#PreTmKot') IS NOT NULL
				DROP TABLE #PreTmKot;
			CREATE TABLE #PreTmKot
			(sug nvarchar(3) NOT NULL, asm int NOT NULL, lak int NOT NULL, paturMaam bit DEFAULT (0) NOT NULL,
			 sumHazLines decimal(25,13) NULL, schum1 money NULL, schum2 money NULL, sumMaam money NULL, sumTotal money NULL,
			 asm2 int NULL, sugMakor nvarchar(3) DEFAULT (N'הל') NULL, tarich datetime NULL, erech datetime NULL, heara nvarchar(MAX) NULL,
			 prt1 tinyint NULL, prt2 tinyint NULL, prt3 tinyint NULL, mll1 tinyint NULL, mll2 tinyint NULL, kotKodPratim int NULL,
			 mahsan nvarchar(3) NULL, isMatah bit DEFAULT (0) NOT NULL, sochen int NULL);
			ALTER TABLE #PreTmKot ADD CONSTRAINT [PreTmKot$PK] PRIMARY KEY ([asm]);

			SET @shlav = 'prepare temp table for hazs Makor';
			IF OBJECT_ID('tempdb..#TmpHazsMakor') IS NOT NULL
				DROP TABLE #TmpHazsMakor;
			CREATE TABLE #TmpHazsMakor (HazNum int NOT NULL, lakNum int NULL, paturMaam bit DEFAULT 0 NOT NULL);
			ALTER TABLE #TmpHazsMakor ADD CONSTRAINT [TmpHazsMakor$PK] PRIMARY KEY ([HazNum]);
			SET @shlav = 'insert into temp table from JSON';
			INSERT INTO #TmpHazsMakor (HazNum)
				SELECT DISTINCT * FROM OpenJson(@jsonHazsNums)
				WITH (rskMsHazmana int)
				WHERE rskMsHazmana IS NOT NULL;
			SET @shlav = 'check if data exists in temp table';
			IF NOT EXISTS(SELECT * FROM #TmpHazsMakor WHERE HazNum IS NOT NULL)
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'דאטה לא חוקי להזנת כותרת תמ.';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;

			SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

			SET @shlav = 'Check mazav of Hazs';
			WITH cteMazav AS
			(
			 SELECT #TmpHazsMakor.HazNum, K.rskKodMazav
			 FROM #TmpHazsMakor INNER JOIN dbo.T05rvKotrot K WITH (NOLOCK) ON K.rskMsHazmana = #TmpHazsMakor.HazNum
			 WHERE K.rskKodMazav = '4'
			)
			SELECT @FoundWrong = COUNT([HazNum]) FROM cteMazav;
			IF ISNULL(@FoundWrong, 0) > 0
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'לא ניתן לשלוח הזמנות בהקפאה ליצירת תמ';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
			WITH cteKotLines AS
			(
			 SELECT #TmpHazsMakor.HazNum, K.rskMsHazmana
			 FROM #TmpHazsMakor INNER JOIN dbo.T05rvKotrot K WITH (NOLOCK) ON K.rskMsHazmana = #TmpHazsMakor.HazNum
					LEFT JOIN dbo.T05rvShurot Sh WITH (NOLOCK) ON Sh.rsdMsHazmana = #TmpHazsMakor.HazNum
			 WHERE Sh.rsdCounter IS NULL
			)			
			SELECT @FoundWrong = COUNT([HazNum]) FROM cteKotLines;
			IF ISNULL(@FoundWrong, 0) > 0
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'נשלחה לשרת בקשה ליצירת תמ עבור הזמנה ללא שורות';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
			WITH cteClosed AS
			(
			 SELECT #TmpHazsMakor.HazNum, K.rskMsHazmana
			 FROM #TmpHazsMakor INNER JOIN dbo.T05rvKotrot K WITH (NOLOCK) ON K.rskMsHazmana = #TmpHazsMakor.HazNum
					INNER JOIN dbo.T05rvShurot Sh WITH (NOLOCK) ON Sh.rsdMsHazmana = #TmpHazsMakor.HazNum
			 WHERE Sh.rsdSagur <> 0  OR K.rskSagur <> 0
			)			
			SELECT @FoundWrong = COUNT([HazNum]) FROM cteClosed;
			IF ISNULL(@FoundWrong, 0) > 0
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'נשלחה לשרת בקשה ליצירת תמ עבור הזמנה עם כותרת סגורה או שורה סגורה.';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
			SET @shlav = 'put customers in temp table';
			WITH cteLaksFromHzs AS
			(
			 SELECT #TmpHazsMakor.[HazNum], K.[rskMsHeshbon], ISNULL(H.[IndPaturMaam], 0) AS 'patooor'
			 FROM #TmpHazsMakor INNER JOIN [dbo].[T05rvKotrot] K WITH (NOLOCK) ON K.rskMsHazmana = #TmpHazsMakor.HazNum
				LEFT JOIN [dbo].[T01IndHesbon] H WITH (NOLOCK) ON H.IndMsHeshbon = K.rskMsHeshbon
			)
			UPDATE #TmpHazsMakor SET lakNum = cteLaksFromHzs.[rskMsHeshbon], paturMaam = cteLaksFromHzs.patooor
				FROM #TmpHazsMakor INNER JOIN cteLaksFromHzs ON cteLaksFromHzs.HazNum = #TmpHazsMakor.HazNum;
			SET @shlav = 'check if missing customers exists';
			IF EXISTS(SELECT * FROM #TmpHazsMakor WHERE HazNum IS NOT NULL AND ISNULL(lakNum, 0) = 0)
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'חסר לקוח להזמנה שנשלחה ליצירת תמ.';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
			SET @shlav = 'check how many new document are required';
			SELECT @Amount = COUNT(DISTINCT lakNum) FROM #TmpHazsMakor WHERE lakNum IS NOT NULL;
			IF @Amount < 1
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'חסרים לקוחות ליצירת תמ.';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
			SET @shlav = 'Set some options';
			SET @finalTmDate = CONVERT(varchar(10), ISNULL(@dateTM, GETDATE()), (23));
			SELECT @prt1 = [sgmKod1], @prt2 = [sgmKod2], @prt3 = [sgmKod3], @mll1 = [sgmMll1], @mll2 = sgmMll2
				FROM [dbo].[T02Sugim] WITH (NOLOCK) WHERE [sgmSugMismach] = N'תמ';
			SELECT @doWriteMaakav = ~([sps].[IsTrueBoolHaadafa](N'הלש005'));
			SELECT @UpdateKodMazav = ~([sps].[IsTrueBoolHaadafa](N'הלש072'));
			SELECT @MuzmanToToday = [sps].[IsTrueBoolHaadafa](N'בשכ032');
			SELECT @doCloseErpSh = [sps].[IsTrueBoolHaadafa](N'בשכ042');
			IF EXISTS(SELECT * FROM [dbo].[T01Shonim] WITH (NOLOCK) WHERE [shnSugMismach] = N'הל' AND [shnMsMismach] IN(SELECT HazNum FROM #TmpHazsMakor))
				SET @doShonim = 1;

			BEGIN TRAN
				SET @shlav = 'get all necessary new ASMs for new documents';
				INSERT INTO #TmpNewASMs (Asm)
					EXEC [sps].[usp_SelectBunchNewNumbers] @kotSug, @Amount;
				SELECT @tmpAmount = COUNT(Asm) FROM #TmpNewASMs WHERE Asm IS NOT NULL;
				IF ISNULL(@tmpAmount, 0) <> @Amount
				BEGIN
					IF @@TRANCOUNT > 0
						ROLLBACK TRAN;
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'המערכת לא הצליחה למצוא מספרי אסמכתא חדשים ליצירת תמ.';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
				
				SET @shlav = 'start build data in table PreTmKot';
				WITH cteStartPre AS
				(SELECT ROW_NUMBER() OVER(ORDER BY lakNum) AS 'rNum', lakNum, CONVERT(bit, MAX(CONVERT(int, paturMaam))) AS thePatoor
				 FROM #TmpHazsMakor WHERE lakNum IS NOT NULL GROUP BY lakNum
				), 
				cteNewTmAsms AS 
				(SELECT ROW_NUMBER() OVER(ORDER BY Asm) AS 'rNum', Asm FROM #TmpNewASMs WHERE Asm IS NOT NULL)
				INSERT INTO #PreTmKot (sug, asm, lak, paturMaam, tarich)
					SELECT @kotSug, cteNewTmAsms.Asm, cteStartPre.lakNum, cteStartPre.thePatoor, @finalTmDate					
					FROM cteNewTmAsms INNER JOIN cteStartPre ON cteStartPre.rNum = cteNewTmAsms.rNum; --FROM cteNewTmAsms CROSS APPLY cteStartPre

				SET @shlav = 'get sum of all lines belong to haz from TmpHazsMakor by lakNum'; --and put in #PreTmKot.sumHazLines
				WITH totLine AS
				(SELECT	[rskMsHeshbon],	CONVERT(decimal(25,13),	SUM(
																		(CONVERT(decimal(25,13), ISNULL(rsdKamut, 0)) * CONVERT(decimal(25,13), ISNULL(rsdMehir, 0))) - 
																		(CONVERT(decimal(25,13), ISNULL(rsdKamut, 0)) * CONVERT(decimal(25,13), ISNULL(rsdMehir, 0)) * CONVERT(decimal(25,13), ISNULL(rsdAhuz, 0)) / CONVERT(decimal(25,13), 100))								
																	)
										) AS 'totShurot', CONVERT(bit, MAX(CONVERT(int, [rskIsMatah]))) AS 'matah'
				FROM	dbo.T05rvShurot INNER JOIN dbo.T05rvKotrot ON dbo.T05rvKotrot.rskMsHazmana = dbo.T05rvShurot.rsdMsHazmana
				WHERE	[rskMsHazmana] IN (SELECT HazNum FROM #TmpHazsMakor WHERE HazNum IS NOT NULL)
				GROUP BY [rskMsHeshbon]		
				)
				UPDATE #PreTmKot SET [sumHazLines] = totLine.[totShurot], isMatah = totLine.[matah]
					FROM totLine INNER JOIN #PreTmKot ON #PreTmKot.[lak] = totLine.[rskMsHeshbon]
					WHERE totLine.[rskMsHeshbon] IS NOT NULL;				
				SET @shlav = 'create bunch as table variable for SP';
				INSERT INTO @bunch (asm, sug, patur, tarich, sumLines, ahuz1, ahuz2, yadani)
					SELECT [asm], [sug], CASE WHEN #PreTmKot.isMatah = 1 THEN 1 ELSE [paturMaam] END, 
						[tarich], [sumHazLines], NULL, NULL, NULL
					FROM #PreTmKot;
				SET @shlav = 'Calculate all schumim in PreTmKot by sumHazLines'; --sent to [sps].[usp_MultiCalcAllNow]
				INSERT INTO #CalcAnswers (asm, schumShurot, newkotSchum1, newkotSchum2, newkotMaam, newkotTotal, ahuz1IfYadani)
					EXEC [sps].[usp_MultiCalcAllNow] @bunch;
				SET @shlav = 'UPDATE PreTmKot with values from CalcAnswers';
				UPDATE #PreTmKot SET [schum1] = [newkotSchum1], [schum2] = [newkotSchum2], [sumMaam] = [newkotMaam], [sumTotal] = [newkotTotal]
					FROM #CalcAnswers INNER JOIN #PreTmKot ON #PreTmKot.asm = #CalcAnswers.asm;
				SET @shlav = 'complete the rest of columns in PreTmKot';
				WITH firstHazs AS
				(SELECT lakNum, MIN(HazNum) AS firstHaz
				 FROM #TmpHazsMakor WHERE lakNum IS NOT NULL GROUP BY lakNum
				), HazData AS
				(SELECT firstHazs.lakNum, firstHazs.firstHaz, K.rskMuzmanLetarich, K.rskEarot, K.rskKodMahsan, K.rskKod1, K.rskKod2, K.rskKod3, K.rskKodPratim, K.rskMsSohen
				 FROM dbo.T05rvKotrot K INNER JOIN firstHazs ON firstHazs.firstHaz = K.rskMsHazmana AND firstHazs.lakNum = K.rskMsHeshbon)  
				UPDATE #PreTmKot SET asm2 = HazData.firstHaz, heara = CASE WHEN LEN(ISNULL(@txt_Heara, '')) = 0 THEN HazData.rskEarot ELSE @txt_Heara END,
							mahsan = ISNULL(HazData.rskKodMahsan, N'1'), prt1 = ISNULL(@prt1, HazData.rskKod1), prt2 = ISNULL(@prt2, HazData.rskKod2),
							prt3 = ISNULL(@prt3, rskKod3), mll1 = @mll1, mll2 = @mll2, kotKodPratim = HazData.rskKodPratim,
							sochen = HazData.rskMsSohen, erech = CASE WHEN #PreTmKot.sumTotal < 0 THEN HazData.rskMuzmanLetarich ELSE CONVERT(varchar(10), GETDATE(), (23)) END
						FROM HazData INNER JOIN #PreTmKot ON #PreTmKot.lak = HazData.lakNum;

				SET @shlav = 'insert KOT TM into T02Kotrot from PreTmKot';
				INSERT INTO dbo.T02Kotrot (kotSug, kotASm, kotMsHeshbon, kotShumShurot, kotSchum1, kotSchum2, kotMaam, kotTotal,
											kotAsm2, kotSugMakor, kotTarich, kotErech, kotHerara, kotKod1, kotKod2, kotKod3, kotMll1, kotMll2,
											kotKodPratim, kotMahsan, kotIsMatahBonShen, kotMsSohen)
					SELECT sug, asm, lak, CONVERT(money, sumHazLines), schum1, schum2, sumMaam, sumTotal, asm2, sugMakor, tarich, 
							erech, heara, prt1, prt2, prt3, mll1, mll2, kotKodPratim, mahsan, isMatah, sochen
					FROM #PreTmKot WHERE sug = @kotSug AND asm IS NOT NULL ORDER BY asm;

				SET @shlav = 'insert Lines TM into T02mlyShurot';
				WITH cteHzLines AS
				(SELECT K.rskMsHeshbon, K.rskMsHazmana, @kotSug AS theSug, S.rsdMsKatalogi, '2' AS sugIdk,
						S.rsdKamut, S.rsdMehir, S.rsdAhuz, S.rsdMsShura, S.rsdCounter, CONVERT([varchar](10),getdate(),(23)) AS theMlyDate,
						N'הל' AS theSugAsmMakor, ROW_NUMBER() OVER(PARTITION BY K.rskMsHeshbon ORDER BY K.rskMsHazmana, S.rsdMsShura, S.rsdCounter) AS theMlyMsShura,
						ISNULL(S.rsdMemo, '') + CASE WHEN LEN(ISNULL(S.rsdNumShinaim, '')) > 0 THEN (CASE WHEN K.rskIsMatah = 1 THEN @TeethWordEng ELSE @TeethWordHeb END) + REPLACE(S.rsdNumShinaim, ',', ', ') ELSE '' END AS theMemo						
				 FROM dbo.T05rvKotrot K INNER JOIN dbo.T05rvShurot S ON S.rsdMsHazmana = K.rskMsHazmana
				 WHERE K.rskMsHazmana IN(SELECT HazNum FROM #TmpHazsMakor)
				), cteTmKot AS
				(SELECT asm, lak, mahsan
				 FROM #PreTmKot WHERE sug = @kotSug AND asm IS NOT NULL
				)
				INSERT INTO dbo.T02mlyShurot (mlyMisparParit, mlyMsHeshbon, mlyMahsan, mlyKamut, mlySugIdkun, mlyMehir, mlyAhuz, mlySugReshuma,
							mlyAsm1, mlyMsShura, mlyTarich, mlySugAsmMakor, mlyMsAsmMakor, mlyMsShuraMakor, mlyMemo)
					SELECT	HL.rsdMsKatalogi, TM.lak, TM.mahsan, HL.rsdKamut, HL.sugIdk, HL.rsdMehir, HL.rsdAhuz, HL.theSug,
							TM.asm, HL.theMlyMsShura, HL.theMlyDate, HL.theSugAsmMakor, HL.rskMsHazmana, HL.rsdMsShura, HL.theMemo
					FROM	cteHzLines HL INNER JOIN cteTmKot TM ON TM.lak = HL.rskMsHeshbon
					ORDER BY TM.asm, HL.theMlyMsShura;
				
				SET @shlav = 'update T02YtrotMly';
				--we need mahsan, parit, sum(kamut) from all the above lines.
				WITH cteKatLines AS
					(SELECT K.rskMsHeshbon, S.rsdMsKatalogi, S.rsdKamut 
					 FROM dbo.T05rvKotrot K INNER JOIN dbo.T05rvShurot S ON S.rsdMsHazmana = K.rskMsHazmana
					 WHERE K.rskMsHazmana IN(SELECT HazNum FROM #TmpHazsMakor) AND S.rsdMsKatalogi IS NOT NULL),
				cteMahsan AS
					(SELECT lak, mahsan FROM #PreTmKot WHERE sug = @kotSug AND asm IS NOT NULL),
				cteJoinThem AS
					(SELECT cteMahsan.mahsan, cteKatLines.rsdMsKatalogi AS parit, cteKatLines.rsdKamut
					 FROM cteKatLines INNER JOIN cteMahsan ON cteMahsan.lak = cteKatLines.rskMsHeshbon),
				 cteSumThem AS
					(SELECT mahsan, parit, SUM(rsdKamut) AS kamut
					 FROM cteJoinThem GROUP BY mahsan, parit)
				  MERGE INTO [dbo].[T02YtrotMly] AS trg
					USING (SELECT * FROM cteSumThem) AS src ON src.mahsan = trg.[ymlMahsan] AND src.parit = trg.[ymlMsParit]
					WHEN MATCHED THEN UPDATE SET trg.[ymlTotYeziot] = ISNULL(trg.[ymlTotYeziot], 0) + CONVERT(int, src.kamut)
					WHEN NOT MATCHED BY TARGET THEN INSERT ([ymlMahsan], [ymlMsParit], [ymlTotYeziot])
						VALUES (src.[mahsan], src.[parit], CONVERT(int, src.[kamut]));
				
				SET @shlav = 'Update Kot Makor';
				WITH cteRvKot AS
					(SELECT HazNum, lakNum FROM #TmpHazsMakor),
				cteTmAsms AS
					(SELECT asm, lak FROM #PreTmKot WHERE sug = @kotSug AND asm IS NOT NULL),
				cteJoinIt AS
					(SELECT cteRvKot.HazNum, cteTmAsms.asm FROM cteRvKot INNER JOIN cteTmAsms ON cteTmAsms.lak = cteRvKot.lakNum)
				UPDATE dbo.T05rvKotrot SET [rskKodMazav] = CASE WHEN @UpdateKodMazav = 1 THEN '3' ELSE dbo.T05rvKotrot.[rskKodMazav] END,
					[rskMuzmanLetarich] = CASE WHEN @MuzmanToToday = 1 THEN CONVERT(varchar(10), GETDATE(), (23)) ELSE dbo.T05rvKotrot.[rskMuzmanLetarich] END,
					[rskSugMismachSoger] = @kotSug, [rskMsMismachSoger] = cteJoinIt.[asm], [rskSagur] = 1,
					[rskDateGmar] = CONVERT(varchar(10), GETDATE(), (23))
					FROM dbo.T05rvKotrot INNER JOIN cteJoinIt ON cteJoinIt.HazNum = dbo.T05rvKotrot.rskMsHazmana;

				SET @shlav = 'Update Lines Makor';
				WITH cteRvKot AS
					(SELECT HazNum, lakNum FROM #TmpHazsMakor),
				cteTmAsms AS
					(SELECT asm, lak FROM #PreTmKot WHERE sug = @kotSug AND asm IS NOT NULL),
				cteJoinIt AS
					(SELECT cteRvKot.HazNum, cteTmAsms.asm FROM cteRvKot INNER JOIN cteTmAsms ON cteTmAsms.lak = cteRvKot.lakNum)
				UPDATE dbo.T05rvShurot SET [rsdSugAsm] = @kotSug, [rsdMisparAsm] = CONVERT(nvarchar(50), cteJoinIt.[asm]), [rsdSagur] = 1
					FROM dbo.T05rvShurot INNER JOIN cteJoinIt ON cteJoinIt.HazNum = dbo.T05rvShurot.rsdMsHazmana;

				IF @doWriteMaakav = 1
					BEGIN
						SET @shlav = 'write maakav';
						WITH cteRvKot AS
							(SELECT rskMsHeshbon, rskMsHazmana, rskStatus, rskMuzmanLetarich FROM dbo.T05rvKotrot
							 WHERE rskMsHazmana IN(SELECT HazNum FROM #TmpHazsMakor)),
						cteTmAsms AS
							(SELECT asm, lak, CONVERT([varchar](10),getdate(),(23)) AS hayom, 
								N'גמור - ת. משלוח מס ' + CONVERT(nvarchar(25), #PreTmKot.asm) + CASE WHEN @ovedName IS NOT NULL THEN N'. מעדכן: ' + @ovedName ELSE N'.' END AS theMemo
							 FROM #PreTmKot WHERE sug = @kotSug AND asm IS NOT NULL),
						cteJoinIt AS
							(SELECT cteRvKot.rskMsHazmana, cteRvKot.rskStatus, cteRvKot.rskMuzmanLetarich, cteTmAsms.asm, cteTmAsms.hayom, cteTmAsms.theMemo
							 FROM cteRvKot INNER JOIN cteTmAsms ON cteTmAsms.lak = cteRvKot.rskMsHeshbon)
						INSERT INTO [dbo].[T05rvMakav] ([rsmMsHazmana], [rsmTarichKnisa], [rsmKodShlav], [rsmMuzmanLetarich], [rsmMemo], [rsmTarichBizua])
							SELECT rskMsHazmana, hayom, rskStatus, rskMuzmanLetarich, theMemo, hayom FROM cteJoinIt;
					END

				IF @doShonim = 1
					BEGIN
						SET @shlav = 'Shonim issue';
						WITH cteRvKot AS
							(SELECT HazNum, lakNum FROM #TmpHazsMakor),
						cteHzShonim AS
							(SELECT shnMsMismach, shnShem, shnKtovet, shnIr, ShnMikud, shnTelfon, ShnFax, ShnPelefon, ShnID, shnEmail FROM [dbo].[T01Shonim] WHERE [shnSugMismach] = N'הל' AND [shnMsMismach] IN(SELECT HazNum FROM cteRvKot)),
						cteTmAsms AS
							(SELECT asm, lak FROM #PreTmKot WHERE sug = @kotSug AND asm IS NOT NULL),
						cteJoinNPlay AS
							(SELECT cteRvKot.*, cteHzShonim.*, cteTmAsms.*
							 FROM cteRvKot INNER JOIN cteTmAsms ON cteTmAsms.lak = cteRvKot.lakNum
								INNER JOIN cteHzShonim ON cteHzShonim.shnMsMismach = cteRvKot.HazNum)
						INSERT INTO [dbo].[T01Shonim] (shnSugMismach, shnMsMismach, shnShem, shnKtovet, shnIr, ShnMikud, shnTelfon, ShnFax, ShnPelefon, ShnID, shnEmail)
							SELECT @kotSug, asm, shnShem, shnKtovet, shnIr, ShnMikud, shnTelfon, ShnFax, ShnPelefon, ShnID, shnEmail
							FROM cteJoinNPlay WHERE asm IS NOT NULL;							 
					END

				IF @doCloseErpSh = 1
					BEGIN
						SET @shlav = 'Mark ERP shlavim as done';
						UPDATE dbo.T05rvShlavim SET [rshTrBzPoal] = GETDATE()
							WHERE [rshMsHaz] IN(SELECT HazNum FROM #TmpHazsMakor) AND [rshReceiving] IS NOT NULL AND [rshTrBzPoal] IS NULL;
					END

				SET @shlav = 'Update T02Sugim';
				UPDATE [dbo].[T02Sugim] SET [dbo].[T02Sugim].[sgmLast] = (SELECT MAX(asm) AS theMaxTmNum FROM #PreTmKot WHERE sug = @kotSug)
					WHERE [dbo].[T02Sugim].[sgmSugMismach] = @kotSug;
				
				SET @shlav = 'Return TM Asms';
				SET @RetVal = 1;
				SELECT [asm] FROM #PreTmKot WHERE [sug] = @kotSug AND [asm] IS NOT NULL ORDER BY [asm];
				SELECT @RetVal AS retVal, @RetErrNum AS retErrNum, @RetErrMsg AS retErrMsg;
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			SET @RetErrNum = ERROR_NUMBER();
			SET @RetErrMsg = 'SQL Server - Database: ' + DB_NAME() + ' - Error in procedure ' + OBJECT_NAME(@@PROCID) + ' in shlav: ' + @shlav + '. Description: ' + ERROR_MESSAGE();		
			SET @RetVal = (-4);
			IF @@TRANCOUNT > 0
				ROLLBACK TRAN;
			INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes])
				VALUES (DB_NAME() + '.' + OBJECT_NAME(@@PROCID), 'Error ' + CONVERT(nvarchar(25), ERROR_NUMBER()) + ' At Line ' + CONVERT(nvarchar(25), ERROR_LINE()), ERROR_MESSAGE());
			SELECT CONVERT(nvarchar(24), NULL) AS nothingHere;
			SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
		END CATCH
END;
GO /*
DECLARE @theJSON nvarchar(MAX);
SET @theJSON = N'[{"rskMsHazmana":199716},{"rskMsHazmana":199739},{"rskMsHazmana":199741},{"rskMsHazmana":199742}]';
EXEC [sps].[usp_MakeTMsByHazKots] @theJSON, '2023-01-22', N'שלום זו הערה של נעם.',N'נעם'
GO
SELECT * FROM dbo.T02Kotrot WHERE kotSug = N'תמ' AND kotASm = 249507
SELECT * FROM dbo.T02mlyShurot WHERE mlySugReshuma = N'תמ' AND mlyAsm1 = 249507 ORDER BY mlyMsShura
SELECT * FROM dbo.T05rvKotrot WHERE rskMsHazmana IN(199739, 199741) ORDER BY rskMsHazmana
SELECT * FROM dbo.T05rvShurot WHERE rsdMsHazmana IN(199739, 199741) ORDER BY rsdMsHazmana, rsdMsShura
GO
SELECT * FROM dbo.T02Kotrot WHERE kotSug = N'תמ' AND kotASm = 249508
SELECT * FROM dbo.T02mlyShurot WHERE mlySugReshuma = N'תמ' AND mlyAsm1 = 249508 ORDER BY mlyMsShura
SELECT * FROM dbo.T05rvKotrot WHERE rskMsHazmana IN(199716, 199742) ORDER BY rskMsHazmana
SELECT * FROM dbo.T05rvShurot WHERE rsdMsHazmana IN(199716, 199742) ORDER BY rsdMsHazmana, rsdMsShura
GO
DECLARE @theJSON nvarchar(MAX);
SET @theJSON = N'[{"rskMsHazmana":199690}]';
EXEC [sps].[usp_MakeTMsByHazKots] @theJSON, '2023-01-22', N'שלום זו הערה של נעם.',N'נעם'
GO
*/

--harshaot nosafot
SELECT * FROM T09Ovdim;
INSERT INTO T30Peulot ([IdPeula], [TeurPeula]) VALUES (11, N'סגירה/פתיחה ידנית של הזמנות בונוס-השן במסך כל ההזמנות');
UPDATE T30Peulot SET SismatPeula = '33333' WHERE IdPeula = 11;
SELECT * FROM T30Peulot;
INSERT INTO T30Harshaot (idPeula, idOved, idHarshaa) SELECT 11, 31, 1;
INSERT INTO T30Harshaot (idPeula, idOved, idHarshaa) SELECT 11, 3, 2;
GO

--for SpeedF05ReshimatMismachimSQL
CREATE VIEW dbo.vwMismachimSQL
AS
SELECT	K.kotRaz, CASE WHEN Sh.shnShem IS NULL THEN I.IndShem ELSE Sh.shnShem END AS shem, K.kotSug, K.kotASm, 
		K.kotAsm2, K.kotMsHeshbon, K.kotTarich, K.kotErech, K.kotTotal, K.kotIshur, K.kotPatuah, K.kotSugYaad,
		K.kotAsm3, K.kotBealim, K.KotMetupal, K.kotSugMakor, K.KotIsFutureIska, K.rv
FROM	dbo.T02Kotrot K WITH (NOLOCK) 
		LEFT JOIN dbo.T02Sugim S WITH (NOLOCK) ON S.sgmSugMismach = K.kotSug
		LEFT JOIN dbo.T01IndHesbon I WITH (NOLOCK) ON I.IndMsHeshbon = K.kotMsHeshbon
		LEFT JOIN dbo.T01Shonim Sh WITH (NOLOCK) ON Sh.shnSugMismach = K.kotSug AND Sh.shnMsMismach = K.kotASm
GO
SELECT * FROM dbo.vwMismachimSQL WHERE kotSug = 'תמ' ORDER BY kotASm DESC, kotTarich DESC, kotRaz DESC
GO

--comma-seperated PO's from [dbo].[T05rvShurot] ([rsdMsHazmana], [rsdPO] List)
CREATE VIEW dbo.vwRsdPOList
AS
WITH cteHavePo AS
(SELECT [rsdMsHazmana], [rsdPO]
FROM [dbo].[T05rvShurot] WITH (NOLOCK)
WHERE [rsdPO] IS NOT NULL GROUP BY [rsdMsHazmana], [rsdPO])
SELECT rsdMsHazmana, STRING_AGG([rsdPO], ',') AS PoList
FROM cteHavePo
GROUP BY rsdMsHazmana
GO

--for the "whole-SQL" version of SpeedF05ShowAllAzmanotSQLPO
ALTER VIEW [dbo].[vwAllHazAllSQL]
AS
SELECT  K.rskMsHazmana, K.rskSagur, K.rskPromised, K.rskMuzmanLetarich, K.rskIshur, K.rskTotalSum, 
		K.rskKodMazav, K.rskMetal, K.rskNumMadbeka, K.rskDateGmar, K.rskTarichKabala, K.rskStatus, 
		K.rskMsHeshbon, K.rskKodRofe, K.rskMeupal, K.rskKufsa, K.rskMsMismachSoger, K.rskTik, 
		K.rskMsMaabada, K.rskPoSource, K.rskArrivalDate, K.rskMedidaDate, K.rskTrackingNumber, 
		CONVERT(int, K.[rv]) AS tmprv, K.rskInHouse, K.rv, R.rsrShem, I.IndMsKvuza,
		CASE WHEN Sh.shnShem IS NULL THEN I.IndShem ELSE Sh.shnShem END AS shem, P.PoList	
FROM	[dbo].[T05rvKotrot] K WITH (NOLOCK)
		LEFT JOIN dbo.T05Rofim R WITH (NOLOCK) ON R.rsrCounter = K.rskKodRofe
		LEFT JOIN T01IndHesbon I WITH (NOLOCK) ON I.IndMsHeshbon = K.rskMsHeshbon
		LEFT JOIN [dbo].[vwQ05Shonim] Sh ON Sh.shnMsMismach = K.rskMsHazmana
		LEFT JOIN dbo.vwRsdPOList P ON P.rsdMsHazmana = K.rskMsHazmana
GO
--SELECT * FROM [dbo].[vwAllHazAllSQL] /*WHERE PoList IS NOT NULL*/ ORDER BY rskTarichKabala DESC, rskMsHazmana DESC
--GO
--[dbo].[vwAllHazAllSQL] is UPDATABLE!

--CHANGE dbo.vwAllHazLinesChildNoLock: add [dbo].[vwQItemOnlyIfyColor].itsColor by katMisparParit (itsColor int):
ALTER VIEW [dbo].[vwAllHazLinesChildNoLock]
AS
SELECT	K.rskMsHazmana, S.rsdMemo, K.rskKodMazav, K.rskMuzmanLetarich, K.rskSagur, 
		K.rskAsm2, K.rskKufsa, K.rskZeva, S.rsdNumShinaim, K.rskStatus, S.rsdKamut, 
		K.rskMeupal, K.rskMsMetupal, K.rskMsHeshbon, K.rskMsOved, S.rsdMehir, 
		S.rsdAhuz, K.rskTik, S.rsdMsShura, S.rsdCounter, S.rsdSugAsm, 
		S.rsdMisparAsm, S.rsdShilaLineKey, S.rsdMsKatalogi, CONVERT(int, S.[rv]) AS tmprv, CONVERT(int, K.[rv]) AS tmprvKot,
		S.[rsdPO], Cl.itsColor
FROM	dbo.T05rvKotrot K WITH (NOLOCK) 
			LEFT JOIN dbo.T05rvShurot S WITH (NOLOCK) ON K.rskMsHazmana = S.rsdMsHazmana
			LEFT JOIN [dbo].[vwQItemOnlyIfyColor] Cl ON Cl.katMisparParit = S.rsdMsKatalogi
GO
--SELECT * FROM [dbo].[vwAllHazLinesChildNoLock] WHERE rskMsHazmana = 2000

--for mismachim kshurim
CREATE VIEW dbo.vwTiedByLines
AS
SELECT mlySugAsmMakor, mlyMsAsmMakor, mlySugReshuma, mlyAsm1
FROM dbo.T02mlyShurot WITH (NOLOCK)
WHERE mlySugAsmMakor IS NOT NULL AND mlyMsAsmMakor IS NOT NULL AND mlySugReshuma IS NOT NULL AND mlyAsm1 IS NOT NULL
GROUP BY mlySugAsmMakor, mlyMsAsmMakor, mlySugReshuma, mlyAsm1
GO
--SELECT * FROM dbo.vwTiedByLines WHERE mlySugReshuma = 'תמ' AND mlyAsm1 = 150841
--SELECT * FROM dbo.vwTiedByLines WHERE mlySugAsmMakor = 'הל' AND mlyMsAsmMakor = 107422
--GO

CREATE VIEW dbo.vwTiedHaByHak
AS
SELECT hak.hakSug AS me_sug, hak.hakMsTnua AS me_ms, hak1.hakSug AS other_sug, hak1.hakMsTnua AS other_ms
FROM dbo.T01hakbala hak WITH (NOLOCK) 
	LEFT JOIN dbo.T01hakbala hak1 WITH (NOLOCK) 
		ON hak.hakMsIska = hak1.hakMsIska
WHERE hak.hakSug = N'חע' AND hak1.hakSug = N'קבע' AND hak.hakDafBank = 0 AND hak1.hakDafBank = 0
GO
--SELECT * FROM dbo.vwTiedHaByHak
--GO

--2 views for dapei barcode shila:
CREATE VIEW [dbo].[vwWholeShilaA4]
AS
SELECT	K.rskMsHazmana, K.rskMeupal, S.rsdPO, S.rsdShilaLineKey, S.rsdMsShura, S.rsdMsKatalogi, K.rskTik, 
		S.rsdNumShinaim, K.rskNextAppointment, K.rskKufsa, K.rskPoSource, K.rskMsHeshbon, K.rskKodRofe, 
		S.rsdCounter, snf.ShilaKodSnif, rof.ShilaNameRofe AS ShilaNameRofe
FROM	dbo.T05rvKotrot K WITH (NOLOCK) 
			INNER JOIN dbo.T05rvShurot S WITH (NOLOCK) ON K.rskMsHazmana = S.rsdMsHazmana
			LEFT JOIN [dbo].[TShilaConvSnifLak] snf WITH (NOLOCK) ON snf.OurNumLakoah = K.rskMsHeshbon
			LEFT JOIN [dbo].[TShilaConvRof] rof WITH (NOLOCK) ON rof.OurNumRofe = K.rskKodRofe
				AND rof.sourceId = K.rskPoSource
WHERE	S.rsdPO IS NOT NULL -- AND K.rskMsHazmana IN (183030, 183029, 183028, 183027, 183026, 183025, 183024) for example...
GO
--SELECT * FROM [dbo].[vwWholeShilaA4] WHERE rskMsHazmana IN (183030, 183029, 183028, 183027, 183026, 183025, 183024)
--GO

CREATE VIEW [dbo].[vwWholeShilaA4ThemMkt]
AS
SELECT base.*, mkt.ShilaMakat
FROM [dbo].[vwWholeShilaA4] base
	LEFT JOIN dbo.TShilaConvMkt mkt WITH (NOLOCK) ON mkt.OurMakat = base.rsdMsKatalogi AND mkt.sourceId = base.rskPoSource
GO
--SELECT * FROM [dbo].[vwWholeShilaA4ThemMkt] WHERE rskMsHazmana IN (183030, 183029, 183028, 183027, 183026, 183025, 183024)
--GO

--view for mismachei-AL in Kol-HaHazmanot:
CREATE VIEW dbo.HazMismacheiAL
AS
WITH DorA AS
(
	SELECT ShK.rskMsHazmana AS Haz, Sh.mlySugReshuma AS sugDorA, Sh.mlyAsm1 AS AsmDorA,
		CONVERT(bit, MAX(CONVERT(int, K.kotPatuah))) AS ClosedKotDorA, MIN(K.kotTarich) AS DtKotDorA
	FROM dbo.T05rvKotrot ShK WITH (NOLOCK)
		LEFT JOIN dbo.T02mlyShurot Sh WITH (NOLOCK) ON ShK.rskMsHazmana = Sh.mlyMsAsmMakor
		LEFT JOIN dbo.T02Kotrot K WITH (NOLOCK) ON Sh.mlyAsm1 = K.kotASm AND Sh.mlySugReshuma = K.kotSug
	WHERE Sh.mlySugAsmMakor = N'הל' AND K.kotRaz IS NOT NULL -- AND ShK.rskMsHazmana = 199500
	GROUP BY ShK.rskMsHazmana, Sh.mlySugReshuma, Sh.mlyAsm1
), 
DorB AS
(
	SELECT Sh.mlySugReshuma AS sugDorB, K.kotTarich AS DtKotDorB, Sh.mlyAsm1 AS asmDorB, 
		K.kotPatuah AS ClosedKotDorB, Sh.mlySugAsmMakor, Sh.mlyMsAsmMakor, K.kotBealim
	FROM dbo.T02mlyShurot Sh WITH (NOLOCK)
		LEFT JOIN dbo.T02Kotrot K WITH (NOLOCK) ON Sh.mlySugReshuma = K.kotSug AND Sh.mlyAsm1 = K.kotASm
		INNER JOIN DorA ON DorA.AsmDorA = Sh.mlyMsAsmMakor AND DorA.sugDorA = Sh.mlySugAsmMakor
	WHERE K.kotRaz IS NOT NULL -- AND Sh.mlyMsAsmMakor = 249483
	GROUP BY Sh.mlySugReshuma, K.kotTarich, Sh.mlyAsm1, K.kotPatuah, Sh.mlySugAsmMakor, Sh.mlyMsAsmMakor, K.kotBealim
)
SELECT	DorA.Haz, DorA.DtKotDorA, DorA.sugDorA, DorA.AsmDorA, DorA.ClosedKotDorA, DorB.DtKotDorB, DorB.sugDorB,
		DorB.asmDorB, DorB.ClosedKotDorB, DorB.kotBealim
FROM	DorA LEFT JOIN DorB ON DorA.AsmDorA = DorB.mlyMsAsmMakor AND DorA.sugDorA = DorB.mlySugAsmMakor
--WHERE DorA.Haz = 199500
--ORDER BY DorA.Haz, DorA.DtKotDorA, DorA.AsmDorA, DorB.DtKotDorB, DorB.asmDorB
GO
--SELECT * FROM dbo.HazMismacheiAL WHERE Haz = 199500 ORDER BY Haz, DtKotDorA, AsmDorA, DtKotDorB, asmDorB
--GO

--Madbeka brosh. Substitute for original Access-Query "Q05NDMbarcode":
--SELECT T05rvKotrot.rskMsHazmana, IIf([shnShem] & ""="",Trim$(Nz([IndShem],"")),[shnShem]) AS lak, T05Rofim.rsrShem AS rof, T05rvKotrot.rskMeupal, T05rvKotrot.rskKufsa, Trim$(Nz([indKazar],"")) AS kazar, T05Shlavim.rslTeurShlav, T01IndHesbon.IndMsHeshbon, T05rvKotrot.rskTarichKabala, T05rvKotrot.rskMuzmanLetarich, T05Rofim.rsrHearotRofe, T05rvKotrot.rskZeva, Q09Mtl.klTeur, T05rvKotrot.rskStatus, T05rvKotrot.rskEarot
--FROM ((((T05rvKotrot LEFT JOIN T01IndHesbon ON T05rvKotrot.rskMsHeshbon = T01IndHesbon.IndMsHeshbon) LEFT JOIN T05Rofim ON T05rvKotrot.rskKodRofe = T05Rofim.rsrCounter) LEFT JOIN T05Shlavim ON T05rvKotrot.rskStatus = T05Shlavim.rslKodShlav) LEFT JOIN Q09Mtl ON T05rvKotrot.rskMetal = Q09Mtl.klKod) LEFT JOIN Q05Shonim ON T05rvKotrot.rskMsHazmana = Q05Shonim.shnMsMismach;

--Here use:
--CASE WHEN Sh.shnShem IS NULL THEN I.IndShem ELSE Sh.shnShem END AS shem, P.PoList
--LEFT JOIN [dbo].[vwQ05Shonim] Sh ON Sh.shnMsMismach = K.rskMsHazmana
--tvf:
--fnGetKlaliBySugAndKod('Mtl', Kod)

------before:
CREATE FUNCTION [dbo].[fnGetKlaliBySugAndKod] (@sugKlali nvarchar(3), @theKod int)
RETURNS TABLE AS RETURN
	SELECT klTable, klKod, klTeur
	FROM dbo.T09Klali WITH (NOLOCK)
	WHERE klTable = @sugKlali AND klKod = @theKod
GO
CREATE VIEW dbo.vwBarcodeLabelQry
AS
SELECT K.rskMsHazmana, CASE WHEN Sh.shnShem IS NULL THEN I.IndShem ELSE Sh.shnShem END AS lak, R.rsrShem AS rof,
	K.rskMeupal, K.rskKufsa, I.[indKazar] AS kazar, Shl.rslTeurShlav, I.IndMsHeshbon, K.rskTarichKabala, 
	K.rskMuzmanLetarich, R.rsrHearotRofe, K.rskZeva, Mtl.klTeur, K.rskStatus, K.rskEarot
FROM dbo.T05rvKotrot K WITH (NOLOCK)
	LEFT JOIN T01IndHesbon I WITH (NOLOCK) ON K.rskMsHeshbon = I.IndMsHeshbon
	LEFT JOIN T05Rofim R WITH (NOLOCK) ON K.rskKodRofe = R.rsrCounter
	LEFT JOIN T05Shlavim Shl WITH (NOLOCK) ON K.rskStatus = Shl.rslKodShlav
	LEFT JOIN [dbo].[vwQ05Shonim] Sh ON Sh.shnMsMismach = K.rskMsHazmana
	OUTER APPLY fnGetKlaliBySugAndKod(N'Mtl', K.rskMetal) Mtl
GO	 
--SELECT * FROM dbo.vwBarcodeLabelQry WHERE rskMsHazmana = 199743
--GO

--view for a linked-view for TM-Ptuhot:
CREATE VIEW dbo.vwTmPtuhot
AS
SELECT K.kotTarich, K.kotASm, K.kotRaz, K.kotPatuah, K.kotSug, K.kotSugMakor, K.kotAsm2, K.kotMsHeshbon, K.kotShumShurot,
	K.kotMaam, K.kotTotal, K.kotMahsan, K.kotIshur, I.IndShem + CASE WHEN Sh.shnShem IS NULL THEN '' ELSE (' (' + Sh.shnShem + ')') END AS IndShem,
	--[T01IndHesbon].[IndShem] & IIf([T01Shonim].[shnShem] Is Null,""," (" & [T01Shonim].[shnShem] & ")") AS IndShem,
	R.rsrShem, Sh.shnShem, KSh.rskMsHazmana, KSh.rskMeupal, KSh.rskKodRofe, KSh.rskMuzmanLetarich, KSh.rskAsm2,
	KSh.rskKufsa, KSh.rskInHouse
FROM dbo.T02Kotrot K WITH (NOLOCK)
	LEFT JOIN dbo.T01IndHesbon I WITH (NOLOCK) ON I.IndMsHeshbon = K.kotMsHeshbon
	LEFT JOIN dbo.T05rvKotrot KSh WITH (NOLOCK) ON KSh.rskMsHazmana = K.kotAsm2
	LEFT JOIN dbo.T05Rofim R WITH (NOLOCK) ON R.rsrCounter = KSh.rskKodRofe
	LEFT JOIN dbo.T01Shonim Sh WITH (NOLOCK) ON Sh.shnSugMismach = K.kotSug AND Sh.shnMsMismach = K.kotASm
WHERE K.kotSug = N'תמ' AND K.kotPatuah = 0
GO
--SELECT * FROM dbo.vwTmPtuhot WHERE kotMsHeshbon = 2136 ORDER BY kotTarich DESC, kotASm DESC
--UPDATE dbo.vwTmPtuhot SET kotIshur = 1 WHERE kotRaz = 212716 --It IS updatable.


--SP for closing TM with 0 sum.
ALTER PROC [sps].[usp_CloseTheseTM0] (@jsonTMNums nvarchar(MAX), @ovedName nvarchar(20))
AS
BEGIN
	DECLARE @shlav varchar(90), @RetVal int, @RetErrNum int, @RetErrMsg nvarchar(4000);
	DECLARE @theComment varchar(100), @tm varchar(3) = N'תמ', @peulatSgira nvarchar(5) = N'סגירה', @RCount int;
	
	SET XACT_ABORT, NOCOUNT ON;
	SELECT @RetVal = (-2), @RetErrNum = NULL, @RetErrMsg = NULL;
	IF LEN(ISNULL(@jsonTMNums,'')) = 0
		BEGIN
			SET @RetErrNum = 666;			
			SET @RetErrMsg = N'חסרים מספרי ת.משלוח בסכום 0 לסגירה.';
			SELECT CONVERT(int, NULL) AS nothingHere;
			SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
			RETURN;
		END;
		SET @shlav = 'check JSON KOT valid';
		IF ISJSON(@jsonTMNums) = 0
			BEGIN
				SET @RetErrNum = 666;				
				SET @RetErrMsg = N'דאטה לא חוקי לסגירת תמ בסכום 0.';
				SELECT CONVERT(int, NULL) AS nothingHere;
				SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
				RETURN;
			END;
	BEGIN TRY
		IF OBJECT_ID('tempdb..#Tmp0TMs') IS NOT NULL
			DROP TABLE #Tmp0TMs;
		CREATE TABLE #Tmp0TMs (TmNum int NOT NULL);
		ALTER TABLE #Tmp0TMs ADD CONSTRAINT [Tmp0TMs$PK] PRIMARY KEY ([TmNum]);
		SET @shlav = 'insert into temp table from JSON';
		INSERT INTO #Tmp0TMs (TmNum)
			SELECT DISTINCT * FROM OpenJson(@jsonTMNums)
			WITH (kotASm int)
			WHERE kotASm IS NOT NULL;
		SET @shlav = 'check temp table';
		IF NOT EXISTS(SELECT * FROM #Tmp0TMs WHERE TmNum IS NOT NULL)
			BEGIN
				SET @RetErrNum = 666;			
				SET @RetErrMsg = N'חסרים מספרי ת.משלוח בסכום 0 בטבלה הזמנית לסגירה.';
				SELECT CONVERT(int, NULL) AS nothingHere;
				SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
				RETURN;
			END;
		WITH CTEOpenAndZero AS
		(SELECT K.kotASm FROM [dbo].[T02Kotrot] K INNER JOIN #Tmp0TMs ON #Tmp0TMs.TmNum = K.kotASm
		 WHERE K.kotSug = N'תמ' AND K.kotPatuah = 0 AND K.kotTotal = 0
		)
		DELETE FROM #Tmp0TMs
			WHERE NOT EXISTS(SELECT * FROM CTEOpenAndZero WHERE kotASm = #Tmp0TMs.TmNum);
		IF NOT EXISTS(SELECT * FROM #Tmp0TMs WHERE TmNum IS NOT NULL)
			BEGIN
				SET @RetErrNum = 666;			
				SET @RetErrMsg = N'חסרים מספרי ת.משלוח בסכום 0 בטבלה הזמנית לסגירה.';
				SELECT CONVERT(int, NULL) AS nothingHere;
				SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
				RETURN;
			END;
		SET @theComment = N'נסגרה ידנית, עקב סכום 0, במסך תעודות משלוח פתוחות בבונוס השן' 
		SET @theComment = @theComment + CASE WHEN LEN(ISNULL(@ovedName, '')) = 0 THEN N'' ELSE N' על-ידי ' + ISNULL(@ovedName, '') END;
		
		--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;		
		BEGIN TRAN
			SET @shlav = 'writing in T09Sgira';
			INSERT INTO dbo.T09Sgira (sgAsm, sgSug, sgTaarich, sgSgPt, sgHearot)
				SELECT TmNum, @tm, GETDATE(), @peulatSgira, @theComment
				FROM #Tmp0TMs;
			SET @shlav = 'Closing the TMs';
			UPDATE [dbo].[T02Kotrot] SET [kotPatuah] = 1
				WHERE [dbo].[T02Kotrot].kotSug = N'תמ' AND [dbo].[T02Kotrot].kotPatuah = 0 
					AND [dbo].[T02Kotrot].kotTotal = 0
					AND [dbo].[T02Kotrot].kotASm IN (SELECT TmNum FROM #Tmp0TMs);			
			SELECT @RCount = @@ROWCOUNT;
			SET @shlav = 'sending SELECTs to caller';
			SET @RetVal = 1;
			SELECT @RCount AS recordsAffected;
			SELECT @RetVal AS retVal, @RetErrNum AS retErrNum, @RetErrMsg AS retErrMsg;
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SET @RetErrNum = ERROR_NUMBER();
		SET @RetErrMsg = 'SQL Server - Database: ' + DB_NAME() + ' - Error in procedure ' + OBJECT_NAME(@@PROCID) + ' in shlav: ' + @shlav + '. Description: ' + ERROR_MESSAGE();		
		SET @RetVal = (-4);
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
		INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes])
			VALUES (DB_NAME() + '.' + OBJECT_NAME(@@PROCID), 'Error ' + CONVERT(nvarchar(25), ERROR_NUMBER()) + ' At Line ' + CONVERT(nvarchar(25), ERROR_LINE()), ERROR_MESSAGE());
		SELECT CONVERT(int, NULL) AS nothingHere;
		SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
	END CATCH
END;
GO

--for Dohot Makdimim TM ptuhot:
CREATE VIEW dbo.vwKotOpenTmRptsBasis
AS
SELECT K.kotPatuah, K.kotSug, K.kotASm, K.kotTarich, K.kotErech, K.kotMsHeshbon
FROM dbo.T02Kotrot K WITH (NOLOCK)
WHERE K.kotPatuah = 0 AND K.kotSug = N'תמ'
GO
ALTER VIEW dbo.vwShuOpenTmRptsBasis
AS
SELECT S.mlyShurotCounter, S.mlySugReshuma, S.mlyAsm1, S.mlyMisparParit, S.mlySagur, S.mlyMsShura, S.mlyKamut, S.mlyMehir, S.mlyAhuz, S.mlyMemo, S.mlySugAsmMakor,
		S.mlyMsAsmMakor, S.mlyMsShuraMakor
FROM dbo.T02mlyShurot S WITH (NOLOCK)
WHERE S.mlySugReshuma = N'תמ' AND S.mlySugAsmMakor = N'הל' AND S.mlySagur = 0
	AND S.mlyMsAsmMakor IS NOT NULL AND S.mlyMsShuraMakor IS NOT NULL
GO
ALTER VIEW dbo.vwForMeshulavNew
AS
SELECT S.mlyShurotCounter, K.kotPatuah, K.kotSug, K.kotASm, K.kotTarich, K.kotErech, K.kotMsHeshbon, S.mlyMisparParit, S.mlySagur, 
	S.mlyMsShura, S.mlyKamut, S.mlyMehir, S.mlyAhuz, S.mlyMemo, S.mlySugAsmMakor, I.IndShem, I.IndMsHeshbon, 
	I.Indtovet, I.IndIr, I.IndMikud, I.IndTelefon, I.IndFax, I.IndPaturMaam, I.indKolelMaam, RS.rsdMsHazmana, 
	RS.rsdMemo, RS.rsdNumShinaim, RS.rsdKamut, RS.rsdMehir, RS.rsdAhuz, RS.rsdMsKatalogi, RK.rskMsHazmana, RK.rskAsm2, 
	RK.rskMeupal, RK.rskKodRofe, RK.rskSugMismachSoger, RK.rskMsMismachSoger, RK.rskSagur, RK.rskMsHeshbon, 
	RK.rskTarichKabala, RK.rskMuzmanLetarich, RK.rskStatus, RK.rskKodMazav, RK.rskKufsa, RK.rskMsOved, 
	R.rsrShem, I.IndPelefon, M.rspMsZehuy, RK.rskPO, RK.rskTrackingNumber, RK.rskInHouse
FROM dbo.vwKotOpenTmRptsBasis K
	INNER JOIN dbo.vwShuOpenTmRptsBasis S ON S.mlySugReshuma = K.kotSug AND S.mlyAsm1 = K.kotASm
	LEFT JOIN dbo.T01IndHesbon I WITH (NOLOCK) ON I.IndMsHeshbon = K.kotMsHeshbon	 
	LEFT JOIN dbo.T05rvShurot RS WITH (NOLOCK) ON RS.rsdMsShura = S.mlyMsShuraMakor 
			AND RS.rsdMsHazmana = S.mlyMsAsmMakor AND RS.rsdMsKatalogi = S.mlyMisparParit 
	LEFT JOIN dbo.T05rvKotrot RK WITH (NOLOCK) ON RK.rskMsHazmana = RS.rsdMsHazmana
	LEFT JOIN dbo.T05Rofim R WITH (NOLOCK) ON R.rsrCounter = RK.rskKodRofe  
	LEFT JOIN dbo.T05Metupalim M WITH (NOLOCK) ON M.rspMisMetupal = RK.rskMsMetupal
GO
--SELECT * FROM dbo.vwForMeshulavNew
--GO

CREATE OR ALTER FUNCTION [sps].[fnCompanyCollectsMaam] ()
RETURNS bit
AS BEGIN
	DECLARE @lngResult int, @bitResult bit;
	SELECT @lngResult = ISNULL([adgSugCompany], 1) FROM [dbo].[T01Hevra] WITH (NOLOCK) WHERE [agdId] IS NOT NULL;
	--[adgSugCompany]'s Values: 1 = Osek Murshe, 2 = Osek Patur, 3 = Malkar.
	--If T01Hevra.adgSugCompany is Null, Let's assume the company is Osek Murshe which has to pay Maam. If we don't know, so be it True.
	IF @lngResult > 3 OR @lngResult < 1 
		SET @lngResult = 1; --Because there are some companies that - using this application - put 0 as their [adgSugCompany].
	IF @lngResult = 1
		SET @bitResult = 1;
	ELSE
		SET @bitResult = 0;
	RETURN @bitResult;
END
GO
--SELECT [sps].[fnCompanyCollectsMaam]() AS 'CompanyCollectsMaam'
--GO
--IF [sps].[fnCompanyCollectsMaam]() = 1 PRINT 'Yes!' ELSE PRINT 'No!';
--GO

CREATE OR ALTER FUNCTION [sps].[fnGetIndAhuzHanahaIf044] (@lakNum int)
RETURNS decimal(6, 2)
AS BEGIN
	DECLARE @decResult decimal(6, 2);
	IF [sps].[IsTrueBoolHaadafa](N'בשכ044') = 0
		SET @decResult = NULL;
	ELSE
		BEGIN
			SELECT @decResult = [IndAhuzHanaha] FROM [dbo].[T01IndHesbon] WITH (NOLOCK)
				WHERE [IndMsHeshbon] = @lakNum;
			IF @decResult IS NOT NULL
				IF @decResult = 0 SET @decResult = NULL;
		END
	RETURN @decResult;		
END
GO
--SELECT [sps].[fnGetIndAhuzHanahaIf044](24) AS lakAhuzHanaha
--GO

CREATE OR ALTER FUNCTION [sps].[fnGetAhuzDiscByTurnover] (@lakNum int, @theSum money)
RETURNS decimal(6, 2)
AS BEGIN
	DECLARE @decResult decimal(6, 2);
	IF ISNULL(@lakNum, 0) = 0 OR ISNULL(@theSum, 0) = 0
		SET @decResult = NULL;
	ELSE
		BEGIN
			SELECT TOP (1) @decResult = [idtAhuzHanaha]
				FROM [dbo].[T01IndDiscountByTurnover] WITH (NOLOCK)
				WHERE [idtCustomerNum] = @lakNum AND idtAhuzHanaha IS NOT NULL AND idtTurnoverBracket <= @theSum
				ORDER BY idtTurnoverBracket DESC;
			IF @decResult IS NOT NULL
				IF @decResult = 0 SET @decResult = NULL;
		END;
	RETURN @decResult;
END
GO
--SELECT [sps].[fnGetAhuzDiscByTurnover](2050, 10000) AS AhuzDiscByTurnover --must be 7.5
--GO

CREATE OR ALTER FUNCTION [sps].[fnFindDateErech] (@lakNum int, @dateHesh datetime)
RETURNS datetime
AS BEGIN
	DECLARE @dateResult datetime, @kodAsh varchar(1) = '', @daysAsh smallint = 0, @wantedDate datetime;
	IF ISNULL(@lakNum, 0) <> 0
		BEGIN
			SELECT @kodAsh = [IndKodAshray], @daysAsh = [IndYemeyAshrai]
				FROM [dbo].[T01IndHesbon] WITH (NOLOCK) WHERE [IndMsHeshbon] = @lakNum;
			IF @kodAsh IS NULL SET @kodAsh = '';
			IF @daysAsh IS NULL SET @daysAsh = 0;
		END
	SELECT @wantedDate = CONVERT([varchar](10),ISNULL(@dateHesh, GETDATE()),(23));
	IF LEN(@kodAsh) = 0
		SELECT @dateResult = DATEADD(day, @daysAsh, @wantedDate);
	ELSE
		BEGIN
			IF @kodAsh = '1' --Lelo Shotef
				SELECT @dateResult = DATEADD(day, @daysAsh, @wantedDate);
			ELSE IF @kodAsh = '2' --Shotef Shvu'i				
				SELECT @dateResult = DATEADD(day, (7 - DATEPART(weekday, @wantedDate) + @daysAsh), @wantedDate);			
			ELSE IF @kodAsh = '3' --Shotef Hodshi
				BEGIN
					SELECT @dateResult = DATEADD(month, 1, @wantedDate);
					SELECT @dateResult = DATETIMEFROMPARTS(DATEPART(YEAR, @dateResult), DATEPART(month, @dateResult), 1, 0, 0, 0, 0);
					SELECT @dateResult = DATEADD(day, (-1), @dateResult);
					SELECT @dateResult = DATEADD(day, @daysAsh, @dateResult);
				END;
			ELSE
				SELECT @dateResult = DATEADD(day, @daysAsh, @wantedDate);
		END; 
	RETURN @dateResult;
END
GO
--SELECT [sps].[fnFindDateErech](1001, GETDATE()) AS theErech
--GO

CREATE OR ALTER PROC [sps].[usp_MakeHESHsByTmKots] (@jsonTMsNums nvarchar(MAX), @dateHesh datetime,
		@txtHanaha decimal(25,13), @txtAsmachta2 int, @txt_Heara nvarchar(MAX), @ovedName nvarchar(20), 
		@prt1 tinyint, @prt2 tinyint, @prt3 tinyint)
AS BEGIN
	DECLARE @shlav varchar(90), @RetVal int, @RetErrNum int, @RetErrMsg nvarchar(4000);
	DECLARE @finalHeshDate datetime, @mll1 tinyint, @mll2 tinyint, @doShonim bit = 0, @finalKotErech datetime;
	DECLARE @FoundWrong int, @kotSug nvarchar(3) = N'חש', @Amount int, @tmpAmount int, @bunch dbo.StructForCalc;
	DECLARE @numPkuda int, @numMehirot int, @numMehirotPturot int, @numMaam int, @companyHasMaam bit;
	DECLARE @minRatz int, @maxRatz int, @i int;
	SET XACT_ABORT, NOCOUNT ON;
	SELECT @RetVal = (-2), @RetErrNum = NULL, @RetErrMsg = NULL;

	SET @shlav = 'check argument';
	IF LEN(ISNULL(@jsonTMsNums,'')) = 0
		BEGIN
			SET @RetErrNum = 666;			
			SET @RetErrMsg = N'חסר/ות תעוד/ות מקור ליצירת חשבונית.';
			SELECT CONVERT(int, NULL) AS nothingHere;
			SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
			RETURN;
		END;
		SET @shlav = 'check JSON KOT valid';
		IF ISJSON(@jsonTMsNums) = 0
			BEGIN
				SET @RetErrNum = 666;				
				SET @RetErrMsg = N'דאטה לא חוקי להזנת כותרת חשבונית.';
				SELECT CONVERT(int, NULL) AS nothingHere;
				SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
				RETURN;
			END;
		
		BEGIN TRY
			SET @shlav = 'temp table for the calculations';
			IF OBJECT_ID('tempdb..#CalcAnswers') IS NOT NULL DROP TABLE #CalcAnswers;
			CREATE TABLE #CalcAnswers 
			(asm int NOT NULL PRIMARY KEY, schumShurot decimal(25,13), newkotSchum1 decimal(25,13), 
			 newkotSchum2 decimal(25,13), newkotMaam decimal(25,13), newkotTotal decimal(25,13), ahuz1IfYadani decimal(25,13));

			SET @shlav = 'prepare temp table for new ASMs';
			IF OBJECT_ID('tempdb..#TmpNewASMs') IS NOT NULL DROP TABLE #TmpNewASMs;
			CREATE TABLE #TmpNewASMs (Asm int NOT NULL);
			ALTER TABLE #TmpNewASMs ADD CONSTRAINT [TmpNewASMs$PK] PRIMARY KEY ([Asm]);

			SET @shlav = 'prepare temp table PreHeshKot';
			IF OBJECT_ID('tempdb..#PreHeshKot') IS NOT NULL DROP TABLE #PreHeshKot;
			CREATE TABLE #PreHeshKot
			([ratz] int IDENTITY(1, 1) NOT NULL PRIMARY KEY, sug nvarchar(3) NOT NULL, asm int NOT NULL, lak int NOT NULL, paturMaam bit DEFAULT (0) NOT NULL,
			 sumTMsLines decimal(25,13) NULL, kotAhuz1 decimal(6,2) NULL, schum1 money NULL, kotAhuz2 decimal(6,2) NULL, schum2 money NULL, sumMaam money NULL, sumTotal money NULL,
			 asm2 int NULL, sugMakor nvarchar(3) DEFAULT (N'תמ') NULL, tarich datetime NULL, erech datetime NULL, heara nvarchar(MAX) NULL,
			 prt1 tinyint NULL, prt2 tinyint NULL, prt3 tinyint NULL, mll1 tinyint NULL, mll2 tinyint NULL, kotKodPratim int NULL,
			 mahsan nvarchar(3) NULL, isMatah bit DEFAULT (0) NOT NULL, sochen int NULL, finalAhuzHanaha decimal(25,13) NULL, shemForTnuot nvarchar(50) NULL);
			--ALTER TABLE #PreHeshKot ADD CONSTRAINT [PreHeshKot$PK] PRIMARY KEY ([asm]);
			CREATE UNIQUE NONCLUSTERED INDEX [PreHeshKot$ix_asm] ON #PreHeshKot ([asm]);

			SET @shlav = 'prepare temp table for TMs Makor';
			IF OBJECT_ID('tempdb..#TmpTMsMakor') IS NOT NULL DROP TABLE #TmpTMsMakor;
			CREATE TABLE #TmpTMsMakor (TmNum int NOT NULL, lakNum int NULL, paturMaam bit DEFAULT 0 NOT NULL);
			ALTER TABLE #TmpTMsMakor ADD CONSTRAINT [TmpTMsMakor$PK] PRIMARY KEY ([TmNum]);
			SET @shlav = 'insert into temp table from JSON';
			INSERT INTO #TmpTMsMakor (TmNum)
				SELECT DISTINCT * FROM OpenJson(@jsonTMsNums)
				WITH (asm int)
				WHERE asm IS NOT NULL;
			SET @shlav = 'check if data exists in temp table';
			IF NOT EXISTS(SELECT * FROM #TmpTMsMakor WHERE TmNum IS NOT NULL)
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'דאטה לא חוקי להזנת כותרת חשבונית.';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;

			SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

			SET @shlav = 'collecting necessary data';
			SELECT @companyHasMaam = [sps].[fnCompanyCollectsMaam]();
			SELECT @numPkuda = ISNULL([nivPkuda2], 0), @numMehirot = [nivMechirot], @numMehirotPturot = [nivPturot], @numMaam = [nivIskaot]
				FROM [dbo].[T01nivharim] WITH (NOLOCK) WHERE [id] IS NOT NULL;
			IF @companyHasMaam = 1
				BEGIN
					IF ISNULL(@numMehirot, 0) = 0 OR ISNULL(@numMaam, 0) = 0
						BEGIN
							SET @RetErrNum = 666;				
							SET @RetErrMsg = N'חסר חשבון מכירות או עסקאות בחשבונות נבחרים. לא ניתן להפיק חשבונית.';
							SELECT CONVERT(int, NULL) AS nothingHere;
							SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
							RETURN;
						END;
					IF [sps].[fnFindMaam](ISNULL(@dateHesh, GETDATE())) = 0
						BEGIN
							SET @RetErrNum = 666;				
							SET @RetErrMsg = N'חסר בהגדרות שיעור המעמ. לא ניתן להפיק חשבונית.';
							SELECT CONVERT(int, NULL) AS nothingHere;
							SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
							RETURN;
						END;
				END
			ELSE
				IF ISNULL(@numMehirotPturot, 0) = 0
					BEGIN
						SET @RetErrNum = 666;				
						SET @RetErrMsg = N'חסר חשבון עסקאות-פטורות בחשבונות נבחרים. לא ניתן להפיק חשבונית.';
						SELECT CONVERT(int, NULL) AS nothingHere;
						SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
						RETURN;
					END;
			SET @shlav = 'Checking if TMs are OK';
			WITH cteKotLines AS
			(
			 SELECT #TmpTMsMakor.TmNum, K.kotASm
			 FROM #TmpTMsMakor 
				INNER JOIN dbo.T02Kotrot K WITH (NOLOCK) ON K.kotASm = #TmpTMsMakor.TmNum
				LEFT JOIN dbo.T02mlyShurot Sh WITH (NOLOCK) ON Sh.mlySugReshuma = K.kotSug AND Sh.mlyAsm1 = K.kotASm
			 WHERE K.kotsug = N'תמ' AND Sh.mlyShurotCounter IS NULL
			)			
			SELECT @FoundWrong = COUNT([TmNum]) FROM cteKotLines;
			IF ISNULL(@FoundWrong, 0) > 0
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'נשלחה לשרת בקשה ליצירת חשבונית עבור תעודת-משלוח ללא שורות';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
			WITH cteClosed AS
			(
			 SELECT #TmpTMsMakor.TmNum, K.kotASm
			 FROM #TmpTMsMakor 
					INNER JOIN dbo.T02Kotrot K WITH (NOLOCK) ON K.kotASm = #TmpTMsMakor.TmNum
					INNER JOIN dbo.T02mlyShurot Sh WITH (NOLOCK) ON Sh.mlySugReshuma = K.kotSug AND Sh.mlyAsm1 = K.kotASm
			 WHERE K.kotsug = N'תמ' AND Sh.mlySagur <> 0  OR K.kotPatuah <> 0
			)			
			SELECT @FoundWrong = COUNT([TmNum]) FROM cteClosed;
			IF ISNULL(@FoundWrong, 0) > 0
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'נשלחה לשרת בקשה ליצירת חשבונית עבור תעודת-משלוח עם כותרת סגורה או שורה סגורה.';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
			SET @shlav = 'put customers in temp table';
			WITH cteLaksFromTMs AS
			(
			 SELECT #TmpTMsMakor.[TmNum], K.[kotMsHeshbon], ISNULL(H.[IndPaturMaam], 0) AS 'patooor'
			 FROM #TmpTMsMakor 
				INNER JOIN [dbo].[T02Kotrot] K WITH (NOLOCK) ON K.kotASm = #TmpTMsMakor.TmNum
				LEFT JOIN [dbo].[T01IndHesbon] H WITH (NOLOCK) ON H.IndMsHeshbon = K.kotMsHeshbon
			 WHERE K.kotsug = N'תמ'
			)
			UPDATE #TmpTMsMakor SET lakNum = cteLaksFromTMs.[kotMsHeshbon], paturMaam = cteLaksFromTMs.patooor
				FROM #TmpTMsMakor INNER JOIN cteLaksFromTMs ON cteLaksFromTMs.TmNum = #TmpTMsMakor.TmNum;
			SET @shlav = 'check if missing customers exists';
			IF EXISTS(SELECT * FROM #TmpTMsMakor WHERE TmNum IS NOT NULL AND ISNULL(lakNum, 0) = 0)
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'חסר לקוח לתעודה שנשלחה ליצירת חשבונית.';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
			SET @shlav = 'check how many new document are required';
			SELECT @Amount = COUNT(DISTINCT lakNum) FROM #TmpTMsMakor WHERE lakNum IS NOT NULL;
			IF @Amount < 1
				BEGIN
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'חסרים לקוחות ליצירת חשבונית.';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
			SET @shlav = 'Set some options';
			SET @finalHeshDate = CONVERT(varchar(10), ISNULL(@dateHesh, GETDATE()), (23));
			SELECT @mll1 = [sgmMll1], @mll2 = sgmMll2
				FROM [dbo].[T02Sugim] WITH (NOLOCK) WHERE [sgmSugMismach] = N'תמ';			
			IF EXISTS(SELECT * FROM [dbo].[T01Shonim] WITH (NOLOCK) WHERE [shnSugMismach] = N'תמ' AND [shnMsMismach] IN(SELECT TmNum FROM #TmpTMsMakor))
				SET @doShonim = 1;

			BEGIN TRAN
				SET @shlav = 'get all necessary new ASMs for new documents';
				INSERT INTO #TmpNewASMs (Asm)
					EXEC [sps].[usp_SelectBunchNewNumbers] @kotSug, @Amount;
				SELECT @tmpAmount = COUNT(Asm) FROM #TmpNewASMs WHERE Asm IS NOT NULL;
				IF ISNULL(@tmpAmount, 0) <> @Amount
				BEGIN
					IF @@TRANCOUNT > 0 ROLLBACK TRAN;
					SET @RetErrNum = 666;				
					SET @RetErrMsg = N'המערכת לא הצליחה למצוא מספרי אסמכתא חדשים ליצירת חשבוניות.';
					SELECT CONVERT(int, NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END;
				
				SET @shlav = 'start build data in table PreHeshKot';
				WITH cteStartPre AS
				(SELECT ROW_NUMBER() OVER(ORDER BY lakNum) AS 'rNum', lakNum, CONVERT(bit, MAX(CONVERT(int, paturMaam))) AS thePatoor
				 FROM #TmpTMsMakor WHERE lakNum IS NOT NULL GROUP BY lakNum
				), 
				cteNewHeshAsms AS 
				(SELECT ROW_NUMBER() OVER(ORDER BY Asm) AS 'rNum', Asm FROM #TmpNewASMs WHERE Asm IS NOT NULL)
				INSERT INTO #PreHeshKot (sug, asm, lak, paturMaam, tarich)
					SELECT @kotSug, cteNewHeshAsms.Asm, cteStartPre.lakNum, cteStartPre.thePatoor, @finalHeshDate					
					FROM cteNewHeshAsms INNER JOIN cteStartPre ON cteStartPre.rNum = cteNewHeshAsms.rNum; --FROM cteNewHeshAsms CROSS APPLY cteStartPre

				SET @shlav = 'get sum of all lines belong to TMs from TmpTMsMakor by lakNum'; --and put in #PreHeshKot.sumTMsLines
				WITH totLine AS
				(SELECT	dbo.T02Kotrot.[kotMsHeshbon], CONVERT(decimal(25,13),	SUM(
																					(CONVERT(decimal(25,13), ISNULL(mlyKamut, 0)) * CONVERT(decimal(25,13), ISNULL(mlyMehir, 0))) - 
																					(CONVERT(decimal(25,13), ISNULL(mlyKamut, 0)) * CONVERT(decimal(25,13), ISNULL(mlyMehir	, 0)) * CONVERT(decimal(25,13), ISNULL(mlyAhuz, 0)) / CONVERT(decimal(25,13), 100))								
																					)
															 ) AS 'totShurot', CONVERT(bit, MAX(CONVERT(int, [kotIsMatahBonShen]))) AS 'matah'
				FROM	dbo.T02mlyShurot INNER JOIN dbo.T02Kotrot ON dbo.T02Kotrot.kotSug = dbo.T02mlyShurot.mlySugReshuma AND dbo.T02Kotrot.kotASm = dbo.T02mlyShurot.mlyAsm1
				WHERE	dbo.T02Kotrot.kotSug = N'תמ' AND dbo.T02Kotrot.kotASm IN (SELECT TmNum FROM #TmpTMsMakor WHERE TmNum IS NOT NULL)
				GROUP BY dbo.T02Kotrot.[kotMsHeshbon]		
				)
				UPDATE #PreHeshKot SET [sumTMsLines] = totLine.[totShurot], isMatah = totLine.[matah]
					FROM totLine INNER JOIN #PreHeshKot ON #PreHeshKot.[lak] = totLine.[kotMsHeshbon]
					WHERE totLine.[kotMsHeshbon] IS NOT NULL;
				
				--Deal with #PreHeshKot.finalAhuzHanaha and #PreHeshKot.erech
				SET @shlav = 'determine AhuzHanaha and dateErech for each';
				WITH CTEHanErech AS
				(SELECT [asm], [lak], [sps].[fnGetIndAhuzHanahaIf044]([lak]) AS lakAhuzHanaha,
				 [sps].[fnGetAhuzDiscByTurnover]([lak], [sumTMsLines]) AS AhuzDiscByTurnover,
				 [sps].[fnFindDateErech]([lak], [tarich]) AS theErech
				 FROM #PreHeshKot WHERE [asm] IS NOT NULL AND [lak] IS NOT NULL)
				UPDATE #PreHeshKot SET [erech] = CTEHanErech.theErech, [finalAhuzHanaha] = 
					CASE WHEN ISNULL(CTEHanErech.[AhuzDiscByTurnover], 0) <> 0 THEN CTEHanErech.[AhuzDiscByTurnover]
					WHEN ISNULL(@txtHanaha, 0) <> 0 THEN @txtHanaha
					WHEN ISNULL(CTEHanErech.[lakAhuzHanaha], 0) <> 0 THEN CTEHanErech.[lakAhuzHanaha]
					ELSE 0 END 
					FROM CTEHanErech INNER JOIN #PreHeshKot ON #PreHeshKot.[lak] = CTEHanErech.[lak] AND #PreHeshKot.[asm] = CTEHanErech.[asm];

				SET @shlav = 'create bunch as table variable for SP';
				INSERT INTO @bunch (asm, sug, patur, tarich, sumLines, ahuz1, ahuz2, yadani)
					SELECT [asm], [sug], CASE WHEN #PreHeshKot.isMatah = 1 THEN 1 ELSE [paturMaam] END, 
						[tarich], [sumTMsLines], [finalAhuzHanaha], NULL, NULL
					FROM #PreHeshKot;
				SET @shlav = 'Calculate all schumim in PreHeshKot by sumTMsLines'; --sent to [sps].[usp_MultiCalcAllNow]
				INSERT INTO #CalcAnswers (asm, schumShurot, newkotSchum1, newkotSchum2, newkotMaam, newkotTotal, ahuz1IfYadani)
					EXEC [sps].[usp_MultiCalcAllNow] @bunch;
				SET @shlav = 'UPDATE PreHeshKot with values from CalcAnswers';
				UPDATE #PreHeshKot SET [schum1] = ROUND([newkotSchum1], 2), [schum2] = ROUND([newkotSchum2], 2), [sumMaam] = ROUND([newkotMaam], 2), [sumTotal] = ROUND([newkotTotal], 2)
					FROM #CalcAnswers INNER JOIN #PreHeshKot ON #PreHeshKot.asm = #CalcAnswers.asm;

				--if #PreHeshKot.[sumTotal] < 0 then set #PreHeshKot.erech = latest kotErech from the TM's
				--of which this Heshbonit is made
				IF EXISTS(SELECT * FROM #PreHeshKot WHERE [sumTotal] < 0 AND [asm] IS NOT NULL AND [lak] IS NOT NULL)
					BEGIN
						SET @shlav = 'set dt.erech of negative-sum-documents';
						WITH cteTmpMakor AS
						(SELECT CONVERT(nvarchar(3), N'תמ') AS sug,[TmNum], [lakNum] 
						 FROM #TmpTMsMakor INNER JOIN #PreHeshKot ON #PreHeshKot.lak = #TmpTMsMakor.lakNum
						 WHERE #PreHeshKot.[sumTotal] < 0 AND #PreHeshKot.[asm] IS NOT NULL AND #PreHeshKot.[lak] IS NOT NULL
						), cteRealTms AS
						(SELECT cteTmpMakor.lakNum, cteTmpMakor.TmNum, K.kotErech
						 FROM dbo.T02Kotrot K INNER JOIN cteTmpMakor ON K.kotSug = cteTmpMakor.sug AND K.kotASm = cteTmpMakor.TmNum
						), EachLakMaxErech AS
						(SELECT lakNum, MAX(kotErech) AS maxErech
						 FROM cteRealTms GROUP BY lakNum
						)
						UPDATE #PreHeshKot SET [erech] = EachLakMaxErech.maxErech
						FROM EachLakMaxErech INNER JOIN #PreHeshKot ON #PreHeshKot.lak = EachLakMaxErech.lakNum
						WHERE #PreHeshKot.[sumTotal] < 0 AND #PreHeshKot.[asm] IS NOT NULL AND #PreHeshKot.[lak] IS NOT NULL;
					END;

				SET @shlav = 'complete the rest of columns in PreHeshKot';
				--Remember we have SP-arguments: @txtAsmachta2 int, @txt_Heara nvarchar(MAX)
				WITH firstTMs AS
				(SELECT lakNum, MIN(TmNum) AS firstTm, CONVERT(nvarchar(3), N'תמ') AS sug
				 FROM #TmpTMsMakor WHERE lakNum IS NOT NULL GROUP BY lakNum
				), TmData AS
				(SELECT firstTMs.lakNum, firstTMs.firstTm, K.kotHerara, K.kotMahsan, K.kotKod1, K.kotKod2, K.kotKod3, K.kotMsSohen
				 FROM dbo.T02Kotrot K INNER JOIN firstTMs ON K.kotSug = firstTMs.sug AND K.kotASm = firstTMs.firstTm AND K.kotMsHeshbon = firstTMs.lakNum
				)  
				UPDATE #PreHeshKot SET asm2 = ISNULL(@txtAsmachta2, TmData.firstTm), 
							heara = CASE WHEN LEN(ISNULL(@txt_Heara, '')) = 0 THEN TmData.kotHerara ELSE @txt_Heara END,
							mahsan = ISNULL(TmData.kotMahsan, N'1'), prt1 = ISNULL(@prt1, TmData.kotKod1), prt2 = ISNULL(@prt2, TmData.kotKod2),
							prt3 = ISNULL(@prt3, TmData.kotKod3), mll1 = @mll1, mll2 = @mll2, sochen = TmData.kotMsSohen
						FROM TmData INNER JOIN #PreHeshKot ON #PreHeshKot.lak = TmData.lakNum;

				SET @shlav = 'find name for tnfPratim';
				--#PreHeshKot.shemForTnuot nvarchar(50) for each Heshbonit
				--[shemForTnuot] is:
				--IF this particular Heshbonit IS shonim (because its first TM is Shonim!)...
				--	then shemForTnuot will contain T01Shonim.shnShem of that first TM.
				--IF not shonim: IF behind this particular Heshbonit there's a single METUPAL (Not various metupalim, but only one) 
				--	then shemForTnuot will contain this one-and-only-metupal. ELSE - it will contain NULL.
				WITH cteAllTms AS
					(SELECT lakNum, TmNum, CONVERT(nvarchar(3), N'תמ') AS sug FROM #TmpTMsMakor),					
				cteHazs AS
					(SELECT DISTINCT TK.sug, TK.TmNum, TK.lakNum, TS.mlyMsAsmMakor AS hazNum
					 FROM cteAllTms TK LEFT JOIN [dbo].[T02mlyShurot] TS ON TS.mlySugReshuma = TK.sug AND TS.mlyAsm1 = TK.TmNum
					 WHERE TS.mlySugAsmMakor IS NULL OR TS.mlySugAsmMakor = N'הל'),
				cteMetupals AS
					(SELECT DISTINCT cteHazs.sug, cteHazs.TmNum, cteHazs.lakNum, RK.rskMeupal
					 FROM cteHazs LEFT JOIN [dbo].[T05rvKotrot] RK ON cteHazs.hazNum = RK.rskMsHazmana),
				cteFinalMetupal AS
					(SELECT sug, TmNum, lakNum, CASE WHEN COUNT([rskMeupal]) = 1 THEN MAX([rskMeupal]) ELSE NULL END AS finalMetupal 
					 FROM cteMetupals GROUP BY sug, TmNum, lakNum),
				cteOnlyFirstTm AS
					(SELECT lakNum, sug, MIN(TmNum) AS frstTm, MIN(finalMetupal) AS thePatientName
					 FROM cteFinalMetupal GROUP BY lakNum, sug),
				cteShonim AS
					(SELECT cm.sug, cm.frstTm, cm.lakNum, cm.thePatientName, MIN(shnm.shnShem) AS oneShnShem
					 FROM cteOnlyFirstTm cm LEFT JOIN [dbo].[T01Shonim] shnm ON shnm.shnSugMismach = cm.sug AND shnm.shnMsMismach = cm.frstTm
					 GROUP BY cm.sug, cm.frstTm, cm.lakNum, cm.thePatientName),
				finalCte AS
					(SELECT lakNum, MIN(ISNULL([oneShnShem], [thePatientName])) AS shemForTnuot
					 FROM cteShonim GROUP BY lakNum)
				UPDATE #PreHeshKot SET #PreHeshKot.shemForTnuot = finalCte.[shemForTnuot]
					FROM finalCte INNER JOIN #PreHeshKot ON finalCte.lakNum = #PreHeshKot.lak;

				SET @shlav = 'insert KOT Hesh into T02Kotrot from PreHeshKot';
				INSERT INTO dbo.T02Kotrot (kotSug, kotASm, kotMsHeshbon, kotShumShurot, kotSchum1, kotSchum2, kotMaam, kotTotal,
						kotAsm2, kotSugMakor, kotTarich, kotErech, kotHerara, kotKod1, kotKod2, kotKod3, kotMll1, kotMll2,
						kotMahsan, kotIsMatahBonShen, kotMsSohen)
					SELECT sug, asm, lak, CONVERT(money, sumTMsLines), schum1, schum2, sumMaam, sumTotal, asm2, ISNULL(sugMakor, N'תמ'), tarich, 
							erech, heara, prt1, prt2, prt3, mll1, mll2, mahsan, isMatah, sochen
					FROM #PreHeshKot WHERE sug = @kotSug AND asm IS NOT NULL ORDER BY asm;

				SET @shlav = 'insert Lines Hesh into T02mlyShurot';
				WITH cteTmLines AS
					(SELECT K.kotMsHeshbon, K.kotASm, @kotSug AS theSug, S.mlyMisparParit, '0' AS sugIdk, ISNULL(S.mlyKamut, 0) AS kmt, ISNULL(S.mlyMehir, 0) AS mhr, ISNULL(S.mlyAhuz, 0) AS ahz,
					 S.mlyMsShura, S.mlyShurotCounter, CONVERT([varchar](10),getdate(),(23)) AS theMlyDate, N'תמ' AS theSugAsmMakor,
					 ROW_NUMBER() OVER(PARTITION BY K.kotMsHeshbon ORDER BY K.kotASm, S.mlyMsShura, S.mlyShurotCounter) AS theMlyMsShura, S.mlyMemo AS theMemo						
					 FROM dbo.T02Kotrot K INNER JOIN dbo.T02mlyShurot S ON S.mlySugReshuma = K.kotSug AND S.mlyAsm1 = K.kotASm					
					 WHERE K.kotASm IN(SELECT TmNum FROM #TmpTMsMakor)), 
				cteHeshsKot AS
					(SELECT asm, lak, mahsan FROM #PreHeshKot WHERE sug = @kotSug AND asm IS NOT NULL)
				INSERT INTO dbo.T02mlyShurot (mlyMisparParit, mlyMsHeshbon, mlyMahsan, mlyKamut, mlySugIdkun, mlyMehir, mlyAhuz, mlySugReshuma, mlyAsm1, mlyMsShura, mlyTarich, mlySugAsmMakor, mlyMsAsmMakor, mlyMsShuraMakor, mlyMemo)
					SELECT HL.mlyMisparParit, TM.lak, TM.mahsan, HL.kmt, HL.sugIdk, HL.mhr, HL.ahz, HL.theSug, TM.asm, HL.theMlyMsShura, HL.theMlyDate, HL.theSugAsmMakor, HL.kotASm, HL.mlyMsShura, HL.theMemo
					FROM cteTmLines HL INNER JOIN cteHeshsKot TM ON TM.lak = HL.kotMsHeshbon
					ORDER BY TM.asm, HL.theMlyMsShura;				
				
				SET @shlav = 'Update Kot Makor'; --kotSugYaad, kotAsm3, kotPatuah
				WITH cteTmKot AS
					(SELECT TmNum, lakNum, CONVERT(nvarchar(3), N'תמ') AS sugTm FROM #TmpTMsMakor),
				cteHeshAsms AS
					(SELECT asm, lak FROM #PreHeshKot WHERE sug = @kotSug AND asm IS NOT NULL),
				cteJoinIt AS
					(SELECT cteTmKot.sugTm, cteTmKot.TmNum, cteHeshAsms.asm FROM cteTmKot INNER JOIN cteHeshAsms ON cteHeshAsms.lak = cteTmKot.lakNum)
				UPDATE dbo.T02Kotrot SET [kotSugYaad] = @kotSug, [kotAsm3] = cteJoinIt.[asm], [kotPatuah] = 1					
					FROM dbo.T02Kotrot INNER JOIN cteJoinIt ON cteJoinIt.TmNum = dbo.T02Kotrot.kotASm
						AND cteJoinIt.sugTm = dbo.T02Kotrot.kotSug;			

				SET @shlav = 'Update Lines Makor'; --mlyMsAsmYaad, mlySugAsmYaad, mlySagur
				WITH cteTmKot AS
					(SELECT TmNum, lakNum, CONVERT(nvarchar(3), N'תמ') AS sugTm FROM #TmpTMsMakor),
				cteHeshAsms AS
					(SELECT asm, lak FROM #PreHeshKot WHERE sug = @kotSug AND asm IS NOT NULL),
				cteJoinIt AS
					(SELECT cteTmKot.sugTm, cteTmKot.TmNum, cteHeshAsms.asm FROM cteTmKot INNER JOIN cteHeshAsms ON cteHeshAsms.lak = cteTmKot.lakNum)
				UPDATE dbo.T02mlyShurot SET [mlySugAsmYaad] = @kotSug, mlyMsAsmYaad = cteJoinIt.asm, mlySagur = 1
					FROM dbo.T02mlyShurot INNER JOIN cteJoinIt ON cteJoinIt.sugTm = dbo.T02mlyShurot.mlySugReshuma AND cteJoinIt.TmNum = dbo.T02mlyShurot.mlyAsm1;
			
				SET @shlav = 'Insert Tnuot';
				--@minRatz int, @maxRatz int, @i int --#PreHeshKot.[ratz] 
				SELECT @minRatz = MIN([ratz]), @maxRatz = MAX([ratz]) FROM #PreHeshKot;
				SET @i = @minRatz;
				WHILE @i <= @maxRatz
					BEGIN
						SET @shlav = 'Insert Tnuot: Hova lak';
						INSERT INTO dbo.T01Tnuot (TnfKodHZ,TnfMsNegdi,TnfSchum,TnfMsHeshbon,TnfAsm1,TnfSugTnua,TnfSugPkuda,TnfPkuda,TnfTarich,TnfErech,TnfPratim)
							SELECT CONVERT(varchar(1), '2') AS hz, CASE WHEN #PreHeshKot.paturMaam = 0 THEN @numMehirot ELSE @numMehirotPturot END AS meh,
							#PreHeshKot.sumTotal, #PreHeshKot.lak, #PreHeshKot.asm, #PreHeshKot.sug, CONVERT(tinyint, 2) AS sgPk,
							@numPkuda AS nmPk, #PreHeshKot.tarich, #PreHeshKot.erech, #PreHeshKot.shemForTnuot
							FROM #PreHeshKot WHERE [ratz] = @i;
						IF EXISTS(SELECT * FROM #PreHeshKot WHERE [ratz] = @i AND #PreHeshKot.sumMaam <> 0)
							BEGIN
								SET @shlav = 'Insert Tnuot: Zchut maam';
								INSERT INTO dbo.T01Tnuot (TnfKodHZ,TnfMsNegdi,TnfSchum,TnfMsHeshbon,TnfAsm1,TnfSugTnua,TnfSugPkuda,TnfPkuda,TnfTarich,TnfErech,TnfPratim)
									SELECT CONVERT(varchar(1), '1') AS hz, #PreHeshKot.lak,
									#PreHeshKot.sumMaam, @numMaam AS nivIsk, #PreHeshKot.asm, #PreHeshKot.sug, CONVERT(tinyint, 2) AS sgPk,
									@numPkuda AS nmPk, #PreHeshKot.tarich, #PreHeshKot.erech, #PreHeshKot.shemForTnuot
									FROM #PreHeshKot WHERE [ratz] = @i;
							END;
						SET @shlav = 'Insert Tnuot: Zchut mehirot';
						INSERT INTO dbo.T01Tnuot (TnfKodHZ,TnfMsNegdi,TnfSchum,TnfMsHeshbon,TnfAsm1,TnfSugTnua,TnfSugPkuda,TnfPkuda,TnfTarich,TnfErech,TnfPratim)
							SELECT CONVERT(varchar(1), '1') AS hz, #PreHeshKot.lak, (#PreHeshKot.sumTotal - ISNULL(#PreHeshKot.sumMaam, 0)) AS netto, 
							CASE WHEN #PreHeshKot.paturMaam = 0 THEN @numMehirot ELSE @numMehirotPturot END AS meh, #PreHeshKot.asm, #PreHeshKot.sug, CONVERT(tinyint, 2) AS sgPk,
							@numPkuda AS nmPk, #PreHeshKot.tarich, #PreHeshKot.erech, #PreHeshKot.shemForTnuot
							FROM #PreHeshKot WHERE [ratz] = @i;
						SET @i = (@i + 1);	
					END;				

				SET @shlav = 'update/insert Ytrot';
				--mehirot zchut
				WITH cteBase AS
					(SELECT p.*, CASE WHEN p.paturMaam = 0 THEN @numMehirot ELSE @numMehirotPturot END AS meh 
					 FROM #PreHeshKot p),
				cteByMehirot AS
					(SELECT meh, SUM(sumTotal - ISNULL(sumMaam, 0)) AS sumNetto
					 FROM cteBase GROUP BY meh)
				MERGE INTO [dbo].[T01Ytrot] AS trg
					USING (SELECT * FROM cteByMehirot) AS src ON trg.ytfMsHeshbon = src.meh
					WHEN MATCHED THEN UPDATE SET trg.[ytfTnuaMizZchut] = ISNULL(trg.[ytfTnuaMizZchut], 0) + src.sumNetto
					WHEN NOT MATCHED BY TARGET THEN INSERT ([ytfMsHeshbon], [ytfTnuaMizZchut]) VALUES (src.[meh], src.[sumNetto]);
				--maam zchut
				WITH cteSumMaam AS
					(SELECT @numMaam AS nivIsk, SUM(sumMaam) AS sumOfAllMaam FROM #PreHeshKot WHERE paturMaam = 0)
				MERGE INTO [dbo].[T01Ytrot] AS trg
					USING (SELECT * FROM cteSumMaam) AS src ON trg.ytfMsHeshbon = src.nivIsk
					WHEN MATCHED THEN UPDATE SET trg.[ytfTnuaMizZchut] = ISNULL(trg.[ytfTnuaMizZchut], 0) + src.sumOfAllMaam
					WHEN NOT MATCHED BY TARGET THEN INSERT ([ytfMsHeshbon], [ytfTnuaMizZchut]) VALUES (src.[nivIsk], src.[sumOfAllMaam]);
				--lakoah hova (ytfTnuaMizHova, each lak, sum total)
				WITH cteTotByLak AS
				(SELECT p.lak, SUM(p.sumTotal) AS theTotal FROM #PreHeshKot p GROUP BY p.lak)
				MERGE INTO [dbo].[T01Ytrot] AS trg
					USING (SELECT * FROM cteTotByLak) AS src ON trg.ytfMsHeshbon = src.lak
					WHEN MATCHED THEN UPDATE SET trg.[ytfTnuaMizHova] = ISNULL(trg.[ytfTnuaMizHova], 0) + src.theTotal
					WHEN NOT MATCHED BY TARGET THEN INSERT ([ytfMsHeshbon], [ytfTnuaMizHova]) VALUES (src.[lak], src.[theTotal]);			

				IF @doShonim = 1
					BEGIN
						SET @shlav = 'Shonim issue';
						WITH cteTmKot AS
							(SELECT TmNum, lakNum FROM #TmpTMsMakor),
						cteTmShonim AS
							(SELECT shnMsMismach, shnShem, shnKtovet, shnIr, ShnMikud, shnTelfon, ShnFax, ShnPelefon, ShnID, shnEmail FROM [dbo].[T01Shonim] WHERE [shnSugMismach] = N'תמ' AND [shnMsMismach] IN(SELECT TmNum FROM cteTmKot)),
						cteHeshAsms AS
							(SELECT asm, lak FROM #PreHeshKot WHERE sug = @kotSug AND asm IS NOT NULL),
						cteJoinNPlay AS
							(SELECT cteTmKot.*, cteTmShonim.*, cteHeshAsms.*
							 FROM cteTmKot INNER JOIN cteHeshAsms ON cteHeshAsms.lak = cteTmKot.lakNum
								INNER JOIN cteTmShonim ON cteTmShonim.shnMsMismach = cteTmKot.TmNum)
						INSERT INTO [dbo].[T01Shonim] (shnSugMismach, shnMsMismach, shnShem, shnKtovet, shnIr, ShnMikud, shnTelfon, ShnFax, ShnPelefon, ShnID, shnEmail)
							SELECT @kotSug, asm, shnShem, shnKtovet, shnIr, ShnMikud, shnTelfon, ShnFax, ShnPelefon, ShnID, shnEmail
							FROM cteJoinNPlay WHERE asm IS NOT NULL;							 
					END;

				SET @shlav = 'Update T02Sugim';
				UPDATE [dbo].[T02Sugim] SET [dbo].[T02Sugim].[sgmLast] = (SELECT MAX(asm) AS theMaxHeshNum FROM #PreHeshKot WHERE sug = @kotSug)
					WHERE [dbo].[T02Sugim].[sgmSugMismach] = @kotSug;

				IF [sps].[IsTrueBoolHaadafa](N'בשכ076') = 1
					BEGIN
						SET @shlav = 'insert To Transmit';
						INSERT INTO dbo.T05Transmit (sug, num) 
							SELECT CONVERT(tinyint, 7) AS theSug, #PreHeshKot.asm FROM #PreHeshKot WHERE sug = @kotSug;
						INSERT INTO dbo.T05Transmit (sug, num) 
							SELECT CONVERT(tinyint, 10) AS theSug, #PreHeshKot.lak 
							FROM #PreHeshKot INNER JOIN [dbo].[T01IndHesbon] H ON H.IndMsHeshbon = #PreHeshKot.lak							
							WHERE #PreHeshKot.sug = @kotSug AND H.indInternet = 1;
					END;
				
				SET @shlav = 'Return HESH Asms';
				SET @RetVal = 1;
				SELECT [asm] FROM #PreHeshKot WHERE [sug] = @kotSug AND [asm] IS NOT NULL ORDER BY [asm];
				SELECT @RetVal AS retVal, @RetErrNum AS retErrNum, @RetErrMsg AS retErrMsg;
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			SET @RetErrNum = ERROR_NUMBER();
			SET @RetErrMsg = 'SQL Server - Database: ' + DB_NAME() + ' - Error in procedure ' + OBJECT_NAME(@@PROCID) + ' in shlav: ' + @shlav + '. Description: ' + ERROR_MESSAGE();		
			SET @RetVal = (-4);
			IF @@TRANCOUNT > 0 ROLLBACK TRAN;
			INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes])
				VALUES (DB_NAME() + '.' + OBJECT_NAME(@@PROCID), 'Error ' + CONVERT(nvarchar(25), ERROR_NUMBER()) + ' At Line ' + CONVERT(nvarchar(25), ERROR_LINE()), ERROR_MESSAGE());
			SELECT CONVERT(int, NULL) AS nothingHere;
			SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
		END CATCH
END;
GO

--view for getting customer primary email-address by a document of his:
CREATE OR ALTER VIEW dbo.vwMailByCustomer
AS
SELECT K.kotSug, K.kotASm, I.indEmail
FROM dbo.T02Kotrot K WITH (NOLOCK) INNER JOIN dbo.T01IndHesbon I WITH (NOLOCK)
	ON K.kotMsHeshbon = I.IndMsHeshbon
GO
--SELECT indEmail FROM dbo.vwMailByCustomer WHERE kotSug = 'חש' AND kotASm = 15000
--GO

--view for getting customer [indHowToSendInvoice] field by a document of his:
CREATE VIEW dbo.vwHowSendByCustomer
AS
SELECT K.kotSug, K.kotASm, I.indHowToSendInvoice
FROM dbo.T02Kotrot K WITH (NOLOCK) INNER JOIN dbo.T01IndHesbon I WITH (NOLOCK)
	ON K.kotMsHeshbon = I.IndMsHeshbon
GO
--SELECT indHowToSendInvoice FROM dbo.vwHowSendByCustomer WHERE kotSug = 'חש' AND kotASm = 15000
--GO


--view for getting customer [IndFax] field by a document of his:
CREATE VIEW dbo.vwFaxByCustomer
AS
SELECT K.kotSug, K.kotASm, I.IndFax
FROM dbo.T02Kotrot K WITH (NOLOCK) INNER JOIN dbo.T01IndHesbon I WITH (NOLOCK)
	ON K.kotMsHeshbon = I.IndMsHeshbon
GO
--SELECT IndFax FROM dbo.vwFaxByCustomer WHERE kotSug = 'חש' AND kotASm = 15000
--GO



Column ''cteShonim.shnShem'' is invalid in the select list 
because it is not contained in either an aggregate function or the GROUP BY clause.