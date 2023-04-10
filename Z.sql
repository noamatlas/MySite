--SQL Script for Brosh-Group
--By Noam Atlas 050-5576278
--beginning on 2022-12-05
--SHLAV-B of SQL Project
-----------------------------------------
--SHLAV-B 004 Migrating all tables to SQL
-----------------------------------------


--1: Table ezrErrorLog
CREATE TABLE [dbo].[ezrErrorLog]
([mkCounter] int IDENTITY(1, 1) NOT NULL,
 [mkDate] datetime NULL,
 [mkTime] datetime NULL,
 [mkFormName] nvarchar(100) NULL,
 [mkDescription] nvarchar(max) NULL,
 [mkNotes] nvarchar(max) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[ezrErrorLog] ADD CONSTRAINT [ezrErrorLog$PK] PRIMARY KEY ([mkCounter])
GO
ALTER TABLE [dbo].[ezrErrorLog] ADD  DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) FOR [mkDate]
GO
ALTER TABLE [dbo].[ezrErrorLog] ADD DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) FOR [mkTime]
GO

--2: Table T01Ashray
CREATE TABLE [dbo].[T01Ashray]
([ashKod] nvarchar(3) NOT NULL,
 [ashTeur] nvarchar(20) NULL,
 [ashKupa] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01Ashray] ADD CONSTRAINT [T01Ashray$PK] PRIMARY KEY ([ashKod])
GO

--3: Table T01Bankim
CREATE TABLE [dbo].[T01Bankim]
([bnkKod] nvarchar(16) NOT NULL,
 [bnkShem] nvarchar(50) NULL,
 --[bnkBikoret] nvarchar(2) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01Bankim] ADD CONSTRAINT [T01Bankim$PK] PRIMARY KEY ([bnkKod])
GO

--4: Table T01hakbala
CREATE TABLE [dbo].[T01hakbala]
([hakCounter] int IDENTITY(1, 1) NOT NULL,
 [hakMsHeshbon] int NULL,
 [hakMsIska] int NULL,
 [hakMsTnua] int NULL,
 [hakSchum] money NULL,
 [hakSiman] nvarchar(1) NULL,
 [hakSug] nvarchar(50) NULL,
 [hakDafBank] bit DEFAULT (0) NOT NULL,
 [hakSiduri] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01hakbala] ADD CONSTRAINT [T01hakbala$PK] PRIMARY KEY ([hakCounter])
GO
CREATE NONCLUSTERED INDEX [T01hakbala$ix_HeshbonVeiska] ON [dbo].[T01hakbala] ([hakMsHeshbon],[hakMsIska]) WHERE [hakMsHeshbon] IS NOT NULL AND [hakMsIska] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T01hakbala$ix_NewIska] ON [dbo].[T01hakbala] ([hakMsIska]) WHERE [hakMsIska] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T01hakbala$ix_NewTnua] ON [dbo].[T01hakbala] ([hakMsTnua]) WHERE [hakMsTnua] IS NOT NULL 
GO
CREATE NONCLUSTERED INDEX [T01hakbala$ix_NewTnuaAndSug] ON [dbo].[T01hakbala] ([hakMsTnua],[hakSug]) WHERE [hakMsTnua] IS NOT NULL AND [hakSug] IS NOT NULL
GO

--5: Table T01haluka
CREATE TABLE [dbo].[T01haluka]
([halCounter] int IDENTITY(1, 1) NOT NULL,
 [halSugismach] nvarchar(3) NULL,
 [hakMsMismach] int NULL,
 [hakMsHeshbon] int NULL,
 [halPratim] nvarchar(60) NULL,
 [halSchum] money NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01haluka] ADD CONSTRAINT [T01haluka$PK] PRIMARY KEY ([halCounter])
GO
CREATE NONCLUSTERED INDEX [T01haluka$ix_Mismach] ON [dbo].[T01haluka] ([halSugismach],[hakMsMismach]) WHERE [halSugismach] IS NOT NULL AND [hakMsMismach] IS NOT NULL
GO

--6: Table T01Hevra
CREATE TABLE [dbo].[T01Hevra]
([hevName] nvarchar(150) NULL,
 [AgdManager] nvarchar(15) NULL,
 [AgdConect] nvarchar(15) NULL,
 [AgdAdress] nvarchar(50) NULL,
 [AgdCity] nvarchar(20) NULL,
 [AgdZipKod] varchar(8) NULL,
 [AgdTaDoar] varchar(10) NULL,
 [AgdZipTaDoar] varchar(8) NULL,
 [AgdPhone1] varchar(20) NULL,
 [AgdPhone2] varchar(20) NULL,
 [AgdPhone3] varchar(20) NULL,
 [AgdFax] varchar(20) NULL,
 [AgdOsek] varchar(50) NULL,
 [AgdMaam] Decimal(6,4) DEFAULT (0) NULL,
 [AgdEmail] varchar(50) NULL,
 [hevLogo] varbinary(max) NULL,
 [AgdAhuzRevah] int DEFAULT (0) NULL,
 [AgdAhuzMahzor] int DEFAULT (0) NULL,
 [AgdDilug] int DEFAULT (0) NULL,
 [AgdNikui] float NULL,
 [AgdMikdamot] float NULL,
 [AdgSize] int DEFAULT (3274) NULL,
 [hevEName] varchar(150) NULL,
 [AgdEManager] varchar(15) NULL,
 [AgdEConect] varchar(15) NULL,
 [AgdEAdress] varchar(150) NULL,
 [AgdECity] varchar(20) NULL,
 [AgdECountry] varchar(30) DEFAULT ('Israel') NULL,
 [AgdETel1] varchar(30) NULL,
 [AgdETel2] varchar(30) NULL,
 [AgdETel3] varchar(30) NULL,
 [AgdEFax] varchar(30) NULL,
 [adgMsvMusad] int NULL,
 [adgMsvSholeah] int NULL,
 [adgConsultant] nvarchar(50) NULL,
 [adgPkidShuma] nvarchar(50) NULL,
 [adgTikNikyi] varchar(50) NULL,
 [adgShnatMas] varchar(4) DEFAULT (YEAR(GETDATE())) NULL,
 [adgNumSnif] nvarchar(5) NULL,
 [adgSnifAddress] nvarchar(250) NULL,
 [adgNikayonID] varchar(50) NULL,
 [adgMinAhuzNK] float DEFAULT (0) NULL,
 [adgAmlaH] float DEFAULT (0) NULL,
 [adgYataPercent] float DEFAULT (0) NULL,
 [adgYataMinUSD] float DEFAULT (0) NULL,
 [adgYataCurr] tinyint NULL,
 [adgSugCompany] int DEFAULT (1) NULL,
 [adgMaamPatur] bit DEFAULT (0) NOT NULL,
 [adgMaamadHev] tinyint NULL,
 [adgShowLogo] bit DEFAULT (0) NOT NULL,
 [adgDateStart] datetime NULL,
 [adgDateEnd] datetime NULL,
 [adgAhuzBL] float DEFAULT (0) NULL,
 [AgdWebsite] varchar(50) NULL,
 [agdNotPeila] bit DEFAULT (0) NOT NULL,
 [agdNumRishionTch] int NULL,
 [agdDargaTch] nvarchar(11) NULL,
 [agdAmlaBasic] float NULL,
 [adgAmlaAdd] float NULL,
 [agdOsekMeshutaf] varchar(12) NULL,
 [agdNumInMeimad] int NULL,
 [agdMaamMonths] tinyint NULL,
 [agdPassNet] nvarchar(16) NULL,
 [AhuzRibit] Decimal(18,2) NULL,
 [SugRibit] nvarchar(1) NULL,
 [IndYemeyAshrai] smallint DEFAULT (0) NULL,
 [nosReactionTime] float DEFAULT (0) NULL,
 [Amla] Decimal(18,2) NULL,
 [AgdRishumCodeSnif] nvarchar(10) NULL,
 [AgdAlertDays] int NULL,
 [AhuzRibitMin] Decimal(18,2) NULL,
 [agdId] int IDENTITY(1, 1) NOT NULL,
 [AgdContactRv] nvarchar(15) NULL,
 [AgdEmailRv] varchar(50) NULL,
 [AgdCheckFormat] int NULL,
 [AgdMetalBarcode] nvarchar(255) NULL,
 [agdShenWarranty] smallint NULL,
 [AgdIhudOsek] varchar(20) NULL,
 [LogoMboss01] varbinary(max) NULL,
 [agdMalveMosdi] bit DEFAULT (0) NOT NULL,
 [agdDaysBeforeService] smallint NULL,
 [agdDaysBeforeExpiration] smallint NULL,
 [agdMonthsAfterInstall] smallint NULL,
 [AgdFDAH] varchar(20) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01Hevra] ADD CONSTRAINT [T01Hevra$PK] PRIMARY KEY ([agdId])
GO
--CREATE NONCLUSTERED INDEX [T01Hevra$ix_adgNikayonID] ON [dbo].[T01Hevra] ([adgNikayonID])
--GO
--CREATE UNIQUE NONCLUSTERED INDEX [T01Hevra$ix_CrnKodMatbea] ON [dbo].[T01Hevra] ([adgYataCurr])
--GO

--7: Table T01IfunHes
CREATE TABLE [dbo].[T01IfunHes]
([ifhRama] varchar(1) CHECK(ifhRama >'0' And ifhRama < '4') NOT NULL,
 [ifhKod] varchar(3) NOT NULL,
 [ifhTeur] nvarchar(100) NULL,
 [ifhMhironYhudi] int NULL,
 [ifhEmail] varchar(30) NULL,
 [rv] rowversion NOT NULL
)
GO
--CREATE NONCLUSTERED INDEX [T01IfunHes$ix_IndMhironYhudi] ON [dbo].[T01IfunHes] ([ifhMhironYhudi])
--GO
ALTER TABLE [dbo].[T01IfunHes] ADD CONSTRAINT [T01IfunHes$PK] PRIMARY KEY ([ifhRama],[ifhKod])
GO

--8: Table T01IndDiscountByTurnover
CREATE TABLE [dbo].[T01IndDiscountByTurnover]
([idtCustomerNum] int NOT NULL,
 [idtTurnoverBracket] money NOT NULL,
 [idtAhuzHanaha] Decimal(6,2) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01IndDiscountByTurnover] ADD CONSTRAINT [T01IndDiscountByTurnover$PK] PRIMARY KEY ([idtCustomerNum],[idtTurnoverBracket])
GO
CREATE NONCLUSTERED INDEX [T01IndDiscountByTurnover$ix_idtCustomerNum] ON [dbo].[T01IndDiscountByTurnover] ([idtCustomerNum])
GO
CREATE NONCLUSTERED INDEX [T01IndDiscountByTurnover$ix_idtTurnoverBracket] ON [dbo].[T01IndDiscountByTurnover] ([idtTurnoverBracket])
GO

--9: Table T01IndHaadafa
CREATE TABLE [dbo].[T01IndHaadafa]
([hdfMsHeshbon] int NOT NULL,
 [hdfMsHaadafa] nvarchar(10) NOT NULL,
 [hdfAnswer] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01IndHaadafa] ADD CONSTRAINT [T01IndHaadafa$PK] PRIMARY KEY ([hdfMsHeshbon],[hdfMsHaadafa])
GO

--10: Table T01IndHesbon
CREATE TABLE [dbo].[T01IndHesbon]
([IndMsHeshbon] int NOT NULL,
 [IndMsKvuza] nvarchar(3) NULL,
 [IndShem] nvarchar(50) NULL,
 [Indtovet] nvarchar(255) NULL,
 [IndIr] nvarchar(50) NULL,
 [IndMikud] varchar(8) NULL,
 [IndTDoar] varchar(5) NULL,
 [IndTelefon] varchar(14) NULL,
 [IndPelefon] varchar(12) NULL,
 [IndFax] varchar(14) NULL,
 [IndMsZehut] varchar(9) NULL,
 [IndEzor] varchar(3) NULL,
 [IndIfun1] varchar(3) NULL,
 [IndIfun2] varchar(3) NULL,
 [IndIfun3] varchar(3) NULL,
 [IndAhuzNikuy] Decimal(4,2) DEFAULT (0) NULL,
 [IndTarichTom] datetime NULL,
 [IndIsukMH] varchar(4) NULL,
 [IndAhuzHanaha] Decimal(6,2) DEFAULT (0) NULL,
 [IndMehirClali] varchar(2) NULL,
 [IndMhironYhudi] int NULL,
 [IndTavlatHanahot] bit DEFAULT (0) NOT NULL,
 [IndKodAshray] varchar(1) NULL,
 [IndYemeyAshrai] smallint DEFAULT (0) NULL,
 [IndMenahel] nvarchar(15) NULL,
 [IndIshKesher] nvarchar(50) NULL,
 [IndSochen] int NULL,
 [IndMisparEzlo] varchar(10) NULL,
 [IndTarichPtiha] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [IndTarichSgira] datetime NULL,
 [IndMugbal] bit DEFAULT (0) NOT NULL,
 [IndPaturMaam] bit DEFAULT (0) NOT NULL,
 [IndMatbea] tinyint NULL,
 [IndHevratAshrai] varchar(3) NULL,
 [IndTarichTokef] datetime NULL,
 [IndMsKartis] varchar(16) NULL,
 [indKodRama] tinyint NULL,
 [IndHeara] nvarchar(max) NULL,
 [indTikratAshrai] int NULL,
 [indTakziv] int NULL,
 [indMasav] bit DEFAULT (0) NOT NULL,
 [indTelHofshi] varchar(30) NULL,
 [indShluha] varchar(4) NULL,
 [indMsKesher] int NULL,
 [indMechirKamut] int NULL,
 [indKolelMaam] bit DEFAULT (0) NOT NULL,
 [indEmail] varchar(250) NULL,
 [indFloor] smallint NULL,
 [indApt] smallint NULL,
 [indPaturMikdamot] bit DEFAULT (0) NOT NULL,
 [indAmlaKlali] float DEFAULT (0) NULL,
 [indKizuz] bit DEFAULT (0) NOT NULL,
 [indOved] int NULL,
 [indNikuyMaam] bit DEFAULT (0) NOT NULL,
 [indMatehet] int NULL,
 [indAhlafa] datetime NULL,
 [indKazar] nvarchar(50) NULL,
 [indRisui] nvarchar(50) NULL,
 [indTikNikuy] int NULL,
 [indShemShuma] nvarchar(10) NULL,
 [indNumShuma] varchar(2) NULL,
 [indSugNikuy] smallint NULL,
 [indSugOsek] tinyint NULL,
 [indHebDate] nvarchar(50) NULL,
 [indSugPayment] smallint NULL,
 [indIfyunMH] varchar(1) NULL,
 [indOsekMeshutaf] varchar(12) NULL,
 [indAhuzPartMaam] real NULL,
 [indHakdamaDays] real DEFAULT (0) NULL,
 [indExitTime] datetime NULL,
 [indKodMahsan] nvarchar(3) NULL,
 [indToOrder] bit DEFAULT (0) NOT NULL,
 [indFiscalStatus] tinyint NULL,
 [indInternet] bit DEFAULT (0) NOT NULL,
 [indUniqueMakats] bit DEFAULT (0) NOT NULL,
 [indForceShenRules] tinyint NULL,
 [shvCVV2] varchar(4) NULL,
 [shvZehut] varchar(9) NULL,
 [IndKtuvetDoarStreet] nvarchar(255) NULL,
 [IndKtuvetDoarCity] nvarchar(255) NULL,
 [DoSendEmail] bit DEFAULT (0) NOT NULL,
 [DoSendSms] bit DEFAULT (0) NOT NULL,
 [txtEmail1] nvarchar(255) NULL, --DEFAULT ('הופקה תעודת משלוח מספר') NULL,
 [txtEmail2] nvarchar(255) NULL, --DEFAULT ('למטופל/ים:') NULL,
 [txtEmail3] nvarchar(255) NULL, --DEFAULT (', העבודה תשלח אליכם') NULL,
 [txtEmail4] nvarchar(255) NULL, --DEFAULT ('בהקדם/תוך') NULL,
 [txtEmail5] nvarchar(255) NULL, --DEFAULT ('בברכה:') NULL,
 [indPopUpMsgNum] int NULL,
 [txtBagEmail1] nvarchar(255) NULL, --DEFAULT ('הופקה שקית מספר') NULL,
 [txtBagEmail2] nvarchar(255) NULL, --DEFAULT ('למטופל/ים:') NULL,
 [txtBagEmail3] nvarchar(255) NULL, --DEFAULT ('העבודה תשלח אליכם בהקדם/תוך ') NULL,
 [txtBagEmail4] nvarchar(255) NULL, --NULL,
 [indHowToSendInvoice] tinyint NULL,
 [indCreditCardOwnerName] nvarchar(255) NULL,
 [indNoteTM] nvarchar(255) NULL,
 [indClinicDays] nvarchar(255) NULL,
 [indClinicTime] nvarchar(255) NULL,
 [indClinicDeliveryGuy] nvarchar(255) NULL,
 [indIsoCountry] nvarchar(2) NULL,
 [IndStoreNum] nvarchar(25) NULL,
 [IndSpecialColor] bit DEFAULT (0) NOT NULL,
 [IndDontPrintBalance] bit DEFAULT (0) NOT NULL,
 [indBlockWithWithoutMaam] bit DEFAULT (0) NOT NULL,
 [indAvoidKlal006] bit DEFAULT (0) NOT NULL,
 [indFavorite] bit DEFAULT (0) NOT NULL,
 [indZihuyNosaf] varchar(3) NULL,
 [2IndHevratAshrai] varchar(2) NULL,
 [2IndMsKartis] varchar(16) NULL,
 [2IndTarichTokef] datetime NULL,
 [2indTikratAshrai] int NULL,
 [2indCreditCardOwnerName] nvarchar(255) NULL,
 [2shvCVV2] varchar(4) NULL,
 [2shvZehut] varchar(9) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01IndHesbon] ADD CONSTRAINT [T01IndHesbon$PK] PRIMARY KEY ([IndMsHeshbon])
GO
CREATE NONCLUSTERED INDEX [T01IndHesbon$ix_shem] ON [dbo].[T01IndHesbon] ([IndShem])
GO
CREATE NONCLUSTERED INDEX [T01IndHesbon$ix_if1] ON [dbo].[T01IndHesbon] ([IndIfun1]) WHERE [IndIfun1] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T01IndHesbon$ix_if2] ON [dbo].[T01IndHesbon] ([IndIfun2]) WHERE [IndIfun2] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T01IndHesbon$ix_if3] ON [dbo].[T01IndHesbon] ([IndIfun3]) WHERE [IndIfun3] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T01IndHesbon$ix_indFavorite] ON [dbo].[T01IndHesbon] ([indFavorite])
--GO
--CREATE NONCLUSTERED INDEX [T01IndHesbon$ix_indIsoCountry] ON [dbo].[T01IndHesbon] ([indIsoCountry])
--GO
CREATE NONCLUSTERED INDEX [T01IndHesbon$ix_kvuza] ON [dbo].[T01IndHesbon] ([IndMsKvuza])
GO
CREATE NONCLUSTERED INDEX [T01IndHesbon$ix_mhiron] ON [dbo].[T01IndHesbon] ([IndMhironYhudi])
GO

--11: Table T01IndHeshbonNosaf
CREATE TABLE [dbo].[T01IndHeshbonNosaf]
([nosMsHeshbon] int NOT NULL,
 [nosReactionTime] float DEFAULT (0) NULL,
 [nosPitaronTime] float DEFAULT (0) NULL,
 [clName] nvarchar(200) NULL,
 [Address] nvarchar(250) NULL,
 [Building] nvarchar(50) NULL,
 [City] nvarchar(100) NULL,
 [Country] nvarchar(100) NULL,
 [Zip] varchar(10) NULL,
 [POB] varchar(10) NULL,
 [Tel1] varchar(50) NULL,
 [Tel2] varchar(50) NULL,
 [Tel3] varchar(50) NULL,
 [AhuzRibit] Decimal(18,2) NULL,
 [SugRibit] nvarchar(1) DEFAULT ('ח') NULL,
 [Amla] Decimal(18,2) NULL,
 [indMatkin] int NULL,
 [indDirug] varchar(1) NULL,
 [indIgulShaot] tinyint NULL,
 [indMinShaot] float DEFAULT (0) NULL,
 [ahuzAmla] float DEFAULT (0) NULL,
 [birthDate] datetime NULL,
 --[indMahsan] int NULL,
 [indMahsan] nvarchar(3) NULL,
 [indMinPercent] float DEFAULT (0) NULL,
 [indSex] nvarchar(2) NULL,
 [indStatus] nvarchar(2) NULL,
 [indDaysTizkoret] int NULL,
 [indTruma] bit DEFAULT (0) NOT NULL,
 [indSugNikayon] tinyint DEFAULT (1) NULL,
 [indAmlaBasic] float NULL,
 [indAmlaAdd] float NULL,
 [indTitle] int NULL,
 [indAmlaPercent] float DEFAULT (0) NULL,
 [IndIhudOsek] varchar(9) NULL,
 [nosPurchasingAcc] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01IndHeshbonNosaf] ADD CONSTRAINT [T01IndHeshbonNosaf$PK] PRIMARY KEY ([nosMsHeshbon])
GO

--12: Table T01IndHeshParents
CREATE TABLE [dbo].[T01IndHeshParents]
([pMsHeshbon] int NOT NULL,
 [pHealth] nvarchar(50) NULL,
 [pNumChildren] nvarchar(50) NULL,
 [pEmergPhone] varchar(50) NULL,
 [pEmergName] nvarchar(50) NULL,
 [pId_m] nvarchar(10) NULL,
 [pName_m] nvarchar(50) NULL,
 [pCountry_m] nvarchar(50) NULL,
 [pWork_m] nvarchar(200) NULL,
 [pOccupation_m] nvarchar(100) NULL,
 [pWorkTel_m] nvarchar(9) NULL,
 [pSolalar_m] nvarchar(10) NULL,
 [pId_f] varchar(10) NULL,
 [pName_f] nvarchar(50) NULL,
 [pCountry_f] nvarchar(50) NULL,
 [pWork_f] nvarchar(200) NULL,
 [pOccupation_f] nvarchar(100) NULL,
 [pWorkTel_f] varchar(9) NULL,
 [pSolalar_f] varchar(10) NULL,
 [pStatus_m] varchar(1) NULL,
 [pStatus_f] varchar(1) NULL,
 [pPassport_m] varchar(30) NULL,
 [pPassport_f] varchar(30) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01IndHeshParents] ADD CONSTRAINT [T01IndHeshParents$PK] PRIMARY KEY ([pMsHeshbon])
GO

--13: Table T01IndMasav
CREATE TABLE [dbo].[T01IndMasav]
([imMsHeshbon] int NULL,
 [imBank] varchar(2) NULL,
 [imSnif] varchar(5) NULL,
 [imHeshBank] varchar(16) NULL,
 [imGroup] int NULL,
 [imCounter] int IDENTITY(1, 1) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01IndMasav] ADD CONSTRAINT [T01IndMasav$PK] PRIMARY KEY ([imCounter])
GO
CREATE NONCLUSTERED INDEX [T01IndMasav$ix_hesh] ON [dbo].[T01IndMasav] ([imMsHeshbon]) WHERE [imMsHeshbon] IS NOT NULL
GO

--14: Table T01InhHearot
CREATE TABLE [dbo].[T01InhHearot]
([inhMsHeshbon] int NOT NULL,
 [inhCounter] int IDENTITY(1, 1) NOT NULL,
 [inhDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [inhMemo] nvarchar(max) NULL,
 [inhTime] datetime DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01InhHearot] ADD CONSTRAINT [T01InhHearot$PK] PRIMARY KEY ([inhCounter])
GO
CREATE NONCLUSTERED INDEX [T01InhHearot$ix_hesh] ON [dbo].[T01InhHearot] ([inhMsHeshbon])
GO

--15: Table T01KvuzotPrimery
CREATE TABLE [dbo].[T01KvuzotPrimery]
([kvSug] nvarchar(2) NOT NULL,
 [kvTeur] nvarchar(100) NULL,
 [kvOrder] int NULL,
 [kvIfun] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01KvuzotPrimery] ADD CONSTRAINT [T01KvuzotPrimery$PK] PRIMARY KEY ([kvSug])
GO

--16: Table T01Kvuzot
CREATE TABLE [dbo].[T01Kvuzot]
([KvuMsKvuza] nvarchar(3) NOT NULL,
 [KvuMsDaf] varchar(3) NULL,
 [KvSugKvuza] nvarchar(2) NULL,
 [KvuTeurKvuza] nvarchar(50) NULL,
 [KvuMeMispar] int NULL,
 [KvuAdMispar] int NULL,
 [KvuMsaharon] int NULL,
 [KvuKodSikum] nvarchar(1) NULL,
 [KvuKodmiun] nvarchar(3) NULL,
 [KvuAsurLiklot] bit DEFAULT (0) NOT NULL,
 [KvuSisma] nvarchar(8) NULL,
 [KvuMahut] tinyint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01Kvuzot] ADD CONSTRAINT [T01Kvuzot$PK] PRIMARY KEY ([KvuMsKvuza])
GO
CREATE NONCLUSTERED INDEX [T01Kvuzot$ix_KvSugKvuza] ON [dbo].[T01Kvuzot] ([KvSugKvuza]) WHERE [KvSugKvuza] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T01Kvuzot$ix_KvuMahut] ON [dbo].[T01Kvuzot] ([KvuMahut]) WHERE [KvuMahut] IS NOT NULL
GO

--17: Table T01Maam
CREATE TABLE [dbo].[T01Maam]
([maaDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NOT NULL,
 [maaRate] float NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01Maam] ADD CONSTRAINT [T01Maam$PK] PRIMARY KEY ([maaDate])
GO

--18: Table T01nivharim
CREATE TABLE [dbo].[T01nivharim]
([nivMechirot] int NULL,
 [nivKniyot] int NULL,
 [nivPturot] int NULL,
 [nivMezuman] int NULL,
 [nivChekim] int NULL,
 [nivAshray] int NULL,
 [nivShtarot] int NULL,
 [nivHaavarot] int NULL,
 [nivKupaAher] int NULL,
 [nivIskaot] int NULL,
 [nivTsumot] int NULL,
 [nivNechasim] int NULL,
 [nivMaamHoz] int NULL,
 [nivMasSapakim] int NULL,
 [nivMasLakohot] int NULL,
 [nivPkuda1] int NULL,
 [nivPkuda2] int NULL,
 [nivPkuda3] int NULL,
 [nivLakShonim] int NULL,
 [nivSapShonim] int NULL,
 [nivPkuda4] int NULL,
 [nivHefreshim] int NULL,
 [nivDate1] datetime NULL,
 [nivDate2] datetime NULL,
 [nivDate3] datetime NULL,
 [nivDate4] datetime NULL,
 [nivBerurim] int NULL,
 [nivZikuiSapak] int NULL,
 [nivBank] int NULL,
 [nivYamimMaam] int DEFAULT (0) NULL,
 [shrShatH] datetime NULL,
 [shrBoker] int NULL,
 [shrErev] int NULL,
 [nivMabada] int NULL,
 [nivAhlafot] int NULL,
 [nivEnd] datetime NULL,
 [nivKamut] int DEFAULT (0) NULL,
 [nivAmlot] int NULL,
 [nivHozrim] int NULL,
 [nivMasav] int NULL,
 [nivNikuyMaam] int NULL,
 [nivBituahLeumi] int NULL,
 [nivAhnasotZefi] int NULL,
 [nivHefrBank] float DEFAULT (0) NULL,
 [mhDate1] datetime NULL,
 [mhDate2] datetime NULL,
 [nivAhnasotAmlaCheque] int NULL,
 [nivAhnasotAmlaHakama] int NULL,
 [id] int IDENTITY(1, 1) NOT NULL,
 [nivProfitLoss] int NULL,
 [nivShaliah] int NULL,
 [nivTazrim] int NULL,
 [nivAhnasotAmlaNihul] int NULL,
 [nivAhnasotAmlaNesiot] int NULL,
 [nivLakConsumptionMaterials] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01nivharim] ADD CONSTRAINT [T01nivharim$PK] PRIMARY KEY ([id])
GO

--19: Table T01pizul
CREATE TABLE [dbo].[T01pizul]
([pzlCounter] int IDENTITY(1, 1) NOT NULL,
 [pzlMsHeshbon] int NULL,
 [pzlSugMismach] nvarchar(3) NULL,
 [pzlMsMismach] int NULL,
 [pzlMsTozati] int NULL,
 [pzlSchumLeloMaam] money NULL,
 [pzlSchumColelMaam] money NULL,
 [pzlSchumMaam] money NULL,
 [pzlPratim] nvarchar(40) NULL,
 [pzlAsm] int NULL,
 [pzlTarich] datetime NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01pizul] ADD CONSTRAINT [T01pizul$PK] PRIMARY KEY ([pzlCounter])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T01pizul$ix_pzlMsHeshbon] ON [dbo].[T01pizul] ([pzlMsHeshbon],[pzlSugMismach],[pzlMsMismach]) WHERE [pzlMsHeshbon] IS NOT NULL AND [pzlSugMismach] IS NOT NULL AND [pzlMsMismach] IS NOT NULL
GO

--20: Table T01PkudotKotrot
CREATE TABLE [dbo].[T01PkudotKotrot]
([pktSugPkuda] nvarchar(3) NOT NULL,
 [pktMisparPkuda] int NOT NULL,
 [pktDate1] datetime NULL,
 [pktDate2] datetime NULL,
 [pktMazav] varchar(1) NULL,
 [pktOved] int NULL,
 [pktBikoretHova] money NULL,
 [pktBikoretZchut] money NULL,
 [pktBikoretMaam] money NULL,
 [pktBikoretNikui] money NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01PkudotKotrot] ADD CONSTRAINT [T01PkudotKotrot$PK] PRIMARY KEY ([pktSugPkuda],[pktMisparPkuda])
GO

--21: Table T01Pkudot
CREATE TABLE [dbo].[T01Pkudot]
([pkuCounter] int IDENTITY(1, 1) NOT NULL,
 [pkuIdkun] bit DEFAULT (0) NOT NULL,
 [pkuMakor] nvarchar(1) NULL,
 [pkuMispar] int NOT NULL,
 [PkuShura] smallint NOT NULL,
 [pkuSug] nvarchar(3) NOT NULL,
 [pkuHaklada] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [pkuTarichAsm] datetime NULL,
 [pkuErech] datetime NULL,
 [pkuHesHova] int NULL,
 [pkuHesZchut] int NULL,
 [pkuSchumHova] money NULL,
 [pkuSchumZchut] money NULL,
 [pkuMaam] money NULL,
 [pkuNikuy] money NULL,
 [pkuAsm1] int NULL,
 [pkuAsm2] int NULL,
 [pkuAsm3] int NULL,
 [pkuMthKod] varchar(2) NULL,
 [pkuMthShaar] Decimal(18,8) NULL,
 [pkuMatahSchum] money NULL,
 [pkuKmtKod] varchar(2) NULL,
 [pkuKmtShaar] Decimal(18,8) NULL,
 [pkuKmt] money NULL,
 [pkuNose] nvarchar(4) NULL,
 [pkuPratim] nvarchar(40) NULL,
 [pkdOved] int NULL,
 [pkuBank] varchar(2) NULL,
 [pkuSnif] varchar(5) NULL,
 [pkuHesBank] varchar(16) NULL,
 [pkuMisparMimsar] varchar(10) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01Pkudot] ADD CONSTRAINT [T01Pkudot$PK] PRIMARY KEY ([pkuCounter])
GO
CREATE NONCLUSTERED INDEX [T01Pkudot$ix_Pkudot] ON [dbo].[T01Pkudot] ([pkuSug], [pkuMispar], [PkuShura])
GO

--22: Table T01Shonim
CREATE TABLE [dbo].[T01Shonim]
([shnSugMismach] nvarchar(3) NOT NULL,
 [shnMsMismach] int NOT NULL,
 [shnShem] nvarchar(50) NULL,
 [shnKtovet] nvarchar(255) NULL,
 [shnIr] nvarchar(50) NULL,
 [ShnMikud] varchar(8) NULL,
 [shnTelfon] varchar(12) NULL,
 [ShnFax] varchar(12) NULL,
 [ShnPelefon] varchar(12) NULL,
 [ShnID] varchar(50) NULL,
 [shnEmail] varchar(250) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01Shonim] ADD CONSTRAINT [T01Shonim$PK] PRIMARY KEY ([shnSugMismach],[shnMsMismach])
GO
--CREATE NONCLUSTERED INDEX [T01Shonim$ix_ShnID] ON [dbo].[T01Shonim] ([ShnID])
--GO

--23: Table T01ShvaError
CREATE TABLE [dbo].[T01ShvaError]
([shvErrorKod] smallint NOT NULL,
 [shvErrorTeur] nvarchar(100) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01ShvaError] ADD CONSTRAINT [T01ShvaError$PK] PRIMARY KEY ([shvErrorKod])
GO

--24: Table T01Snifim
CREATE TABLE [dbo].[T01Snifim]
([snfKodBank] tinyint NOT NULL,
 [snfKodSnif] smallint NOT NULL,
 [snfShem] nvarchar(25) NULL,
 [snfKtovet] nvarchar(25) NULL,
 [snfIr] nvarchar(15) NULL,
 [snfTelefon] varchar(11) NULL,
 [snfMikud] varchar(8) NULL,
 [snfFax] varchar(11) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01Snifim] ADD CONSTRAINT [T01Snifim$PK] PRIMARY KEY ([snfKodBank],[snfKodSnif])
GO

--25: Table T01SugTnuot
CREATE TABLE [dbo].[T01SugTnuot]
([sgtSugTnua] nvarchar(3) NOT NULL,
 [sgtTeut] nvarchar(20) NULL,
 [sgtSamanHova] nvarchar(1) NULL,
 [sgtMisHenHova] int NULL,
 [sgtSamanZchut] nvarchar(1) NULL,
 [sgtMisHenZchut] int NULL,
 [sgtSamanMaam] nvarchar(1) NULL,
 [sgtMisHenMaam] int NULL,
 [sgtSamanNikuy] nvarchar(1) NULL,
 [sgtMisHenNikuy] int NULL,
 [sgtShiaruch] varchar(1) NULL,
 [sgtAhuzMaam] Decimal(6,2) NULL,
 [sgtSugPeula] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01SugTnuot] ADD CONSTRAINT [T01SugTnuot$PK] PRIMARY KEY ([sgtSugTnua])
GO

--26: Table T01Tnuot
CREATE TABLE [dbo].[T01Tnuot]
([TnfCounter] int IDENTITY(1, 1) NOT NULL,
 [TnfMsHeshbon] int NOT NULL,
 [TnfMsNegdi] int NULL,
 [TnfSugPkuda] tinyint DEFAULT (0) NULL,
 [TnfPkuda] int DEFAULT (0) NULL,
 [TnfShura] smallint NULL,
 [TnfSugTnua] nvarchar(3) NULL,
 [TnfHaklada] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [TnfTarich] datetime NULL,
 [TnfErech] datetime NULL,
 [TnfSchum] money DEFAULT (0) NULL,
 [TnfKodHZ] varchar(1) CHECK(TnfKodHZ = '1' OR TnfKodHZ = '2') NULL,
 [TnfAsm1] int NULL,
 [TnfAsm2] int DEFAULT (0) NULL,
 [TnfAsm3] int NULL,
 [TnfHukbal] money DEFAULT (0) NULL,
 [TnfPatuah] bit DEFAULT (0) NOT NULL,
 [TnfMatah] money DEFAULT (0) NULL,
 [TnfMatbea] varchar(1) NULL,
 [TnfKamut] money DEFAULT (0) NULL,
 [TnfMatbea2] varchar(1) NULL,
 [TnfPratim] nvarchar(250) NULL,
 [TnfSugMimsar] varchar(2) NULL,
 [TnfMisparMimsar] varchar(10) NULL,
 [TnfHevratAshray] nvarchar(2) NULL,
 [TnfBank] varchar(10) NULL,
 [TnfSnif] varchar(5) NULL,
 [TnfHesBank] varchar(16) NULL,
 [TnfMakor] varchar(4) NULL,
 [TnfSchumBefoal] money DEFAULT (0) NULL,
 [TnfOdef] money DEFAULT (0) NULL,
 [TnfNikuy] money DEFAULT (0) NULL,
 [TnfRelIska] bit DEFAULT (0) NOT NULL,
 [TnfBealim] nvarchar(50) NULL,
 [tnfOved] int NULL,
 [TnfIshur] bit DEFAULT (0) NOT NULL,
 [TnfID] varchar(20) NULL,
 [tnfYamim] int DEFAULT (0) NULL,
 [tnfRibit] float DEFAULT (0) NULL,
 [tnfProject] int NULL,
 [tnfShar] float DEFAULT (0) NULL,
 [tnfMugbal] bit DEFAULT (0) NOT NULL,
 [tnfShva] int NULL,
 [tnfScratch] bit DEFAULT (0) NOT NULL,
 [tnfPrinted] bit DEFAULT (0) NOT NULL,
 [tnfCanceledBy] int NULL,
 [tnfICanceledIt] int NULL,
 [TnfIsoCountry] varchar(2) NULL,
 [TnfCounterMakor] int NULL,
 [TnfSugTnuaMakor] nvarchar(3) NULL,
 [TnfAsm1Makor] int NULL,
 [TnfShuraMakor] smallint NULL,
 [TnfMsHakbala] int NULL,
 [TnfNikSchumMakor] money DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01Tnuot] ADD CONSTRAINT [T01Tnuot$PK] PRIMARY KEY ([TnfCounter])
GO
CREATE NONCLUSTERED INDEX [T01Tnuot$ix_hakMsIska] ON [dbo].[T01Tnuot] ([TnfMsHakbala]) WHERE [TnfMsHakbala] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T01Tnuot$ix_HeshbonVeErech] ON [dbo].[T01Tnuot] ([TnfMsHeshbon],[TnfErech]) WHERE [TnfErech] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T01Tnuot$ix_HeshbonVeTarich] ON [dbo].[T01Tnuot] ([TnfMsHeshbon],[TnfTarich]) WHERE [TnfTarich] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T01Tnuot$ix_SugPkudaVePkusa] ON [dbo].[T01Tnuot] ([TnfSugPkuda],[TnfPkuda],[TnfCounter])
--GO
--CREATE NONCLUSTERED INDEX [T01Tnuot$ix_TnfCounterMakor] ON [dbo].[T01Tnuot] ([TnfCounterMakor])
--GO
--CREATE NONCLUSTERED INDEX [T01Tnuot$ix_TnfID] ON [dbo].[T01Tnuot] ([TnfID])
--GO
--CREATE NONCLUSTERED INDEX [T01Tnuot$ix_tnfOved] ON [dbo].[T01Tnuot] ([tnfOved])
--GO
CREATE NONCLUSTERED INDEX [T01Tnuot$ix_HeshIncl] ON [dbo].[T01Tnuot] ([TnfMsHeshbon])
	INCLUDE ([TnfSchum],[TnfKodHZ])
GO

--27: Table T01TnuotKBI
CREATE TABLE [dbo].[T01TnuotKBI]
([TnfCounter] int IDENTITY(1, 1) NOT NULL,
 [TnfMsHeshbon] int NULL,
 [TnfMsNegdi] int NULL,
 [TnfAsm1] int NULL,
 [TnfSugTnua] nvarchar(3) NULL,
 [TnfErech] datetime NULL,
 [TnfSchum] Decimal(18,2) DEFAULT (0) NULL,
 [TnfHukbal] Decimal(18,2) DEFAULT (0) NULL,
 [TnfSugMimsar] varchar(2) NULL,
 [TnfMisparMimsar] varchar(10) NULL,
 [TnfHesBank] varchar(16) NULL,
 [TnfSnif] varchar(3) NULL,
 [TnfHevratAshray] nvarchar(2) NULL,
 [TnfBank] varchar(2) NULL,
 [TnfIshur] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01TnuotKBI] ADD CONSTRAINT [T01TnuotKBI$PK] PRIMARY KEY ([TnfCounter])
GO

--28: Table T01Ytrot
CREATE TABLE [dbo].[T01Ytrot]
([YtfCounter] int IDENTITY(1, 1) NOT NULL,
 [ytfMsHeshbon] int NOT NULL,
 [ytfYtratPtiha] money DEFAULT (0) NULL,
 [ytfYtPtiMatah] money NULL,
 [ytfYtPtiKamot] money NULL,
 [ytfTnuaMizHova] money DEFAULT (0) NULL,
 [ytfTnuaMizZchut] money DEFAULT (0) NULL,
 [ytfTnuaMizMatahHova] money NULL,
 [ytfTnuaMizMatahZchut] money NULL,
 [ytfTnuaMizKamutHova] money NULL,
 [ytfTnuaMizKamutZchut] money NULL,
 [ytfHukbalPtiha] money DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T01Ytrot] ADD CONSTRAINT [T01Ytrot$PK] PRIMARY KEY ([YtfCounter])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T01Ytrot$ix_MsHeshbon] ON [dbo].[T01Ytrot] ([ytfMsHeshbon])
GO

--29: Table T02CalendarTizkorot
CREATE TABLE [dbo].[T02CalendarTizkorot]
([tzkCounter] int IDENTITY(1, 1) NOT NULL,
 [tzkDate] datetime NULL,
 [tzkTime] datetime NULL,
 [tzkInterval] int DEFAULT (0) NULL,
 [tzkSubject] nvarchar(max) NULL,
 [tzkOff] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02CalendarTizkorot] ADD CONSTRAINT [T02CalendarTizkorot$PK] PRIMARY KEY ([tzkCounter])
GO

--30: Table T02IfunPar
CREATE TABLE [dbo].[T02IfunPar]
([ifpKodRama] varchar(1) CHECK(ifpKodRama >'0' And ifpKodRama < '6') NOT NULL,
 [ifpkod] varchar(3) NOT NULL,
 [ifpteur] nvarchar(100) NULL,
 [ifpkodKKesherRama1] varchar(3) NULL,
 [ifpkodKKesherRama2] varchar(3) NULL,
 [ifpkodKKesherRama3] varchar(3) NULL,
 [ifpkodKKesherRama4] varchar(3) NULL,
 [ifpkodKKesherRama5] varchar(3) NULL,
 [itsColor] int DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02IfunPar] ADD CONSTRAINT [T02IfunPar$PK] PRIMARY KEY ([ifpKodRama], [ifpkod])
GO
CREATE NONCLUSTERED INDEX [T02IfunPar$ix_itsColor] ON [dbo].[T02IfunPar] ([itsColor])
GO

--31: Table T02InfParit
CREATE TABLE [dbo].[T02InfParit]
([mifCounter] int IDENTITY(1, 1) NOT NULL,
 [mifParit] nvarchar(24) NULL,
 [mifSort] varchar(5) NULL,
 [mifPratim] nvarchar(255) NULL,
 [rv] rowversion NOT NULL
)
GO
--CREATE NONCLUSTERED INDEX [T02InfParit$ix_mifParit] ON [dbo].[T02InfParit] ([mifParit],[mifSort])
--GO
ALTER TABLE [dbo].[T02InfParit] ADD CONSTRAINT [T02InfParit$PK] PRIMARY KEY ([mifCounter])
GO

--32: Table T02KatHearot
CREATE TABLE [dbo].[T02KatHearot]
([kahMsKatalogi] nvarchar(24) NOT NULL,
 [kahCounter] int IDENTITY(1, 1) NOT NULL,
 [kahDate] datetime NULL,
 [kahMemo] nvarchar(max) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02KatHearot] ADD CONSTRAINT [T02KatHearot$PK] PRIMARY KEY ([kahCounter])
GO
CREATE NONCLUSTERED INDEX [T02KatHearot$ix_makat] ON [dbo].[T02KatHearot] ([kahMsKatalogi])
GO

--33: Table T02katKniyot
CREATE TABLE [dbo].[T02katKniyot]
([kakMisparParit] nvarchar(24) NOT NULL,
 [kakCounter] int IDENTITY(1, 1) NOT NULL,
 [kakTarich] datetime NULL,
 [kakKamut] money NULL,
 [kakMehir] money NULL,
 [kakSapak] int NULL,
 [kakSugAsm] nvarchar(3) NULL,
 [kakAsm] int NULL,
 [kakAsmEzlo] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02katKniyot] ADD CONSTRAINT [T02katKniyot$PK] PRIMARY KEY ([kakCounter])
GO
CREATE NONCLUSTERED INDEX [T02katKniyot$ix_makat] ON [dbo].[T02katKniyot] ([kakMisparParit])
GO

--34: Table T02katParitim
CREATE TABLE [dbo].[T02katParitim]
([katCounter] int IDENTITY(1, 1) NOT NULL,
 [katMisparParit] nvarchar(24) NULL,
 [katTeurParit] nvarchar(120) NULL,
 [katTeurYehida] nvarchar(10) NULL,
 [katAriza] varchar(3) NULL,
 [katIfun1] varchar(3) NULL,
 [katIfun2] varchar(3) NULL,
 [katIfun3] varchar(3) NULL,
 [katMiun] varchar(5) NULL,
 [katSivug] nvarchar(1) NULL,
 [katSugMehira] nvarchar(3) NULL,
 [katTeurLOazi] varchar(120) NULL,
 [katMahsan] nvarchar(3) NULL,
 [katMIkum] varchar(11) NULL,
 [katOrech] real DEFAULT (0) NULL,
 [katRohav] real DEFAULT (0) NULL,
 [katOvi] real DEFAULT (0) NULL,
 [katMishkal] real DEFAULT (0) NULL,
 [katPaturMaam] bit DEFAULT (0) NOT NULL,
 [katHeara] nvarchar(max) NULL,
 [katMehir] money NULL,
 [katMehirMin] money DEFAULT (0) NULL,
 [katMehirMax] money DEFAULT (0) NULL,
 [katAhuz] Decimal(4,2) DEFAULT (0) NULL,
 [katYatzran] int DEFAULT (0) NULL,
 [katSapak] int NULL,
 [katPicture] varbinary(max) NULL,
 [katKodMatbea] tinyint NULL,
 [katMehirMatah] money DEFAULT (0) NULL,
 [katMakatYazran] nvarchar(16) NULL,
 [katMakatMekuzar] nvarchar(6) NULL,
 [katMehirSofi] money DEFAULT (0) NULL,
 [katBarCode] varchar(20) NULL,
 [katMsKesher] nvarchar(24) NULL,
 [katText] int NULL,
 [katImgName] nvarchar(255) NULL,
 [katMekadem] float DEFAULT (0) NULL,
 [katHashala] smallint NULL,
 [katNefah] float DEFAULT (0) NULL,
 [katYzur] bit DEFAULT (0) NOT NULL,
 [katAzva] nvarchar(16) NULL,
 [katHamara] float DEFAULT (1) NULL,
 [katRevah] money DEFAULT (0) NULL,
 [katPagTokef] datetime NULL,
 [katSugParit] tinyint DEFAULT (0) NULL,
 [katNumYzur] nvarchar(24) NULL,
 [katMeasureType] bit DEFAULT (0) NOT NULL,
 [katVolumeQty] float DEFAULT (0) NULL,
 [katVolumeType] nvarchar(10) NULL,
 [katWeightQty] float DEFAULT (0) NULL,
 [katWeightType] nvarchar(10) NULL,
 [katMeasureConvert] float DEFAULT (0) NULL,
 [katDaysChange] int NULL,
 [katMaabada] bit DEFAULT (0) NOT NULL,
 [katEnterMaabada] datetime NULL,
 [katIshur] bit DEFAULT (0) NOT NULL,
 [katHatkana] bit DEFAULT (0) NOT NULL,
 [katPrisa] real DEFAULT (0) NULL,
 [katDepNum] tinyint NULL,
 [katExitWithin] tinyint NULL,
 [katMonthsWarranty] smallint CHECK(katMonthsWarranty BETWEEN 0 And 999) NULL,
 [katKodShlav] nvarchar(4) NULL,
 [katWorkDays] smallint NULL,
 [katMakatCustomer] nvarchar(24) NULL,
 [katNotActive] bit DEFAULT (0) NOT NULL,
 [katPrintBarcode] bit DEFAULT (0) NOT NULL,
 [katAvizarSerail] tinyint DEFAULT (0) CHECK(katAvizarSerail BETWEEN 0 AND 2) NULL,
 [katForTiles] bit DEFAULT (0) NOT NULL,
 [katIfun4] varchar(3) NULL,
 [katIfun5] varchar(3) NULL,
 [katFinalCustPrice] money NULL,
 [katColor] tinyint NULL,
 [katAllowMinus] bit DEFAULT (0) NOT NULL,
 [katMakatLakoah] nvarchar(24) NULL,
 [KatKamutMishtah] int NULL,
 [KatAvoidReports] bit DEFAULT (0) NOT NULL,
 [katIsPackage] bit DEFAULT (0) NOT NULL,
 [katPackageWeight] float NULL,
 [katItemsInPackage] float NULL,
 [katPackageItemWeight] float NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02katParitim] ADD CONSTRAINT [T02katParitim$PK] PRIMARY KEY ([katCounter])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T02katParitim$ix_Makat] ON [dbo].[T02katParitim] ([katMisparParit])
GO
--CREATE NONCLUSTERED INDEX [T02katParitim$ix_katAvizarSerail] ON [dbo].[T02katParitim] ([katAvizarSerail])
--GO
CREATE NONCLUSTERED INDEX [T02katParitim$ix_katBarCode] ON [dbo].[T02katParitim] ([katBarCode]) WHERE [katBarCode] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T02katParitim$ix_katColor] ON [dbo].[T02katParitim] ([katColor])
--GO
CREATE NONCLUSTERED INDEX [T02katParitim$ix_katIfun1] ON [dbo].[T02katParitim] ([katIfun1]) WHERE [katIfun1] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T02katParitim$ix_katIfun2] ON [dbo].[T02katParitim] ([katIfun2]) WHERE [katIfun2] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T02katParitim$ix_katIfun3] ON [dbo].[T02katParitim] ([katIfun3]) WHERE [katIfun3] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T02katParitim$ix_katIfun4] ON [dbo].[T02katParitim] ([katIfun4]) WHERE [katIfun4] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T02katParitim$ix_katIfun5] ON [dbo].[T02katParitim] ([katIfun5]) WHERE [katIfun5] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T02katParitim$ix_katKodShlav] ON [dbo].[T02katParitim] ([katKodShlav])
--GO
--CREATE NONCLUSTERED INDEX [T02katParitim$ix_katMakatYazran] ON [dbo].[T02katParitim] ([katMakatCustomer])
--GO
--CREATE UNIQUE NONCLUSTERED INDEX [T02katParitim$ix_katMisparParit] ON [dbo].[T02katParitim] ([katMakatLakoah])
--GO
CREATE NONCLUSTERED INDEX [T02katParitim$ix_katMsKesher] ON [dbo].[T02katParitim] ([katMsKesher]) WHERE [katMsKesher] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T02katParitim$ix_katNotActive] ON [dbo].[T02katParitim] ([katNotActive])
--GO
--CREATE NONCLUSTERED INDEX [T02katParitim$ix_katPrintBarcode] ON [dbo].[T02katParitim] ([katPrintBarcode])
--GO
--CREATE NONCLUSTERED INDEX [T02katParitim$ix_katPrintBarcode1] ON [dbo].[T02katParitim] ([katForTiles])
--GO
--CREATE NONCLUSTERED INDEX [T02katParitim$ix_katSivug] ON [dbo].[T02katParitim] ([katSivug])
--GO
CREATE NONCLUSTERED INDEX [T02katParitim$ix_TeurParit] ON [dbo].[T02katParitim] ([katTeurParit]) WHERE [katTeurParit] IS NOT NULL
GO

--35: Table T02katRechesh
CREATE TABLE [dbo].[T02katRechesh]
([karCounter] int IDENTITY(1, 1) NOT NULL,
 [karMisparParit] nvarchar(24) NULL,
 [katKodMatbea] tinyint NULL,
 [karMehirMummlaz] money NULL,
 [karMehirFob] money NULL,
 [karTamhir] money NULL,
 [karMinimum] money NULL,
 [karMaximum] money NULL,
 [karMInHazmana] money NULL,
 [karYamimMin] smallint NULL,
 [karYamimMax] smallint NULL,
 [karAlutFifo] money NULL,
 [karAlutMemuza] money NULL,
 [karAhuzAmasa1] float DEFAULT (0) NULL,
 [karAhuzAmasa2] float DEFAULT (0) NULL,
 [karMehirCIF] float DEFAULT (0) NULL,
 [karAhuzHanaha] float DEFAULT (0) NULL,
 [BudgetItem] nvarchar(24) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02katRechesh] ADD CONSTRAINT [T02katRechesh$PK] PRIMARY KEY ([karCounter])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T02katRechesh$ix_karMisparParit] ON [dbo].[T02katRechesh] ([karMisparParit])
GO
CREATE NONCLUSTERED INDEX [T02katRechesh$ix_BudgetItem] ON [dbo].[T02katRechesh] ([BudgetItem]) WHERE [BudgetItem] IS NOT NULL
GO

--36: Table T02KotNotes
CREATE TABLE [dbo].[T02KotNotes]
([hrCounter] int IDENTITY(1, 1) NOT NULL,
 [hrAsm] int NULL,
 [hrSug] nvarchar(3) NULL,
 [hrDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [hrNotes] nvarchar(max) NULL,
 [hrTime] datetime DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) NULL,
 [rskFileName] nvarchar(100) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02KotNotes] ADD CONSTRAINT [T02KotNotes$PK] PRIMARY KEY ([hrCounter])
GO
CREATE NONCLUSTERED INDEX [T02KotNotes$ix_AsmSug] ON [dbo].[T02KotNotes] ([hrSug], [hrAsm]) WHERE [hrSug] IS NOT NULL AND [hrAsm] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T02KotNotes$ix_rskFileName] ON [dbo].[T02KotNotes] ([rskFileName]) WHERE [rskFileName] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T02KotNotes$ix_theDate] ON [dbo].[T02KotNotes] ([hrDate])
--GO

--37: Table T02Kotrot
CREATE TABLE [dbo].[T02Kotrot]
([kotRaz] int IDENTITY(1, 1) NOT NULL,
 [kotPatuah] bit DEFAULT (0) NOT NULL,
 [kotSug] nvarchar(3) NOT NULL,
 [kotASm] int NOT NULL,
 [kotSugMakor] nvarchar(3) NULL,
 [kotAsm2] int NULL,
 [kotSugYaad] nvarchar(3) NULL,
 [kotAsm3] int NULL,
 [kotMsHeshbon] int NULL,
 [kotMsSohen] int NULL,
 [kotMsOved] int NULL,
 [kotHaklada] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [kotTarich] datetime NULL,
 [kotErech] datetime NULL,
 [kotShumShurot] money NULL,
 [kotAhuz1] Decimal(6,2) NULL,
 [kotSchum1] money NULL,
 [kotAhuz2] Decimal(6,2) NULL,
 [kotSchum2] money NULL,
 [kotMaam] money NULL,
 [kotTotal] money NULL,
 [kotSchumMatah] money NULL,
 [kotKodMatah] varchar(2) NULL,
 [kotShaar] money DEFAULT (0) NULL,
 --[kotMahsan] smallint NULL,
 [kotMahsan] nvarchar(3) NULL,
 [kotTeurAshray] nvarchar(255) NULL,
 [kotTeurAspaka] nvarchar(30) NULL,
 [kotAsmLakoah] nvarchar(30) NULL,
 [kotIshKesher] nvarchar(50) NULL,
 [kotHerara] nvarchar(max) NULL,
 [kotKod1] nvarchar(3) NULL,
 [kotKod2] nvarchar(3) NULL,
 [kotKod3] nvarchar(3) NULL,
 [kotMll1] nvarchar(3) NULL,
 [kotMll2] nvarchar(3) NULL,
 [kotMll3] nvarchar(3) NULL,
 [kotNose] nvarchar(50) NULL,
 [kotMovil] nvarchar(20) NULL,
 [kotRechev] nvarchar(10) NULL,
 [kotSholeah] nvarchar(20) NULL,
 [kotTarichMish] datetime NULL,
 [KotHudpas] bit DEFAULT (0) NOT NULL,
 [kotIshur] bit DEFAULT (0) NOT NULL,
 [kosStatus1] nvarchar(3) NULL,
 [kotStatus2] nvarchar(3) NULL,
 [kotSchumNosaf] money DEFAULT (0) NULL,
 [kotPicture] varbinary(max) NULL,
 [kotMahsanNegdi] nvarchar(3) NULL, --int NULL,
 [kotKodPratim] int NULL,
 [kotAhuzRibit] float DEFAULT (0) NULL,
 [kotAmla] float DEFAULT (0) NULL,
 [kotID] nvarchar(20) NULL,
 [kotBealim] nvarchar(50) NULL,
 [kotTarichBizua] datetime NULL,
 [kotSumAmla] float DEFAULT (0) NULL,
 [kotSumRibit] float DEFAULT (0) NULL,
 [kotProject] int NULL,
 [kotYemeiAshrai] int DEFAULT (0) NULL,
 [kotMahlaka] nvarchar(4) NULL,
 [kotHoze] int NULL,
 [kotNikui] float DEFAULT (0) NULL,
 [kotBefoal] float NULL,
 [kotDateStatus] datetime NULL,
 [kotTime] datetime DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) NULL,
 [kotSugNikayon] tinyint DEFAULT (1) NULL,
 [kotIsMatahBonShen] bit DEFAULT (0) NOT NULL,
 [kotLastYtraForRibit] money NULL,
 [kotDateLastYtra] datetime NULL,
 [kotSumRibitYtra] money NULL,
 [kotCustomerNum] int NULL,
 [KotIsFutureIska] bit DEFAULT (0) NOT NULL,
 [kotFATFcountry] bit DEFAULT (0) NOT NULL,
 [kotAmlaHakama] float DEFAULT (0) NULL,
 [kotAmlaCheque] float DEFAULT (0) NULL,
 [kotNoteTM] nvarchar(255) NULL,
 [KotKabalaHaluka] bit DEFAULT (0) NOT NULL,
 [KotStoreNum] int NULL,
 [KotBolNum] int NULL,
 [kotDateZfHaskara] datetime NULL,
 [kotAhuzAmla] float DEFAULT (0) NULL,
 [kotPriority] int NULL,
 [KotLoanNoRibit] bit DEFAULT (0) NOT NULL,
 [KotMetupal] nvarchar(30) NULL,
 [KodRofe] int NULL, --smallint NULL,
 [KotMsMetupal] int NULL,
 [kotDmeyNihul] float DEFAULT (0) NULL,
 [kotDmeyNesiot] float DEFAULT (0) NULL,
 [kotAshrayHogen] bit DEFAULT (0) NOT NULL,
 [kotAhuzPigurimRibit] float NULL,
 [kotAllowedFee] int NULL,
 [kotEquipPlace] nvarchar(255) NULL,
 [kotEquipFreeTime] nvarchar(255) NULL,
 [kotEquipFreeSopak] nvarchar(255) NULL,
 [kotEquipFreeHazar] nvarchar(255) NULL,
 [kotSchumHovala] money NULL,
 [kotHazHaskaraConfirmed] bit DEFAULT (0) NOT NULL,
 [KotHazHaskaraPerform] bit DEFAULT (0) NOT NULL,
 [kotAshrayHogenThirdParty] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02Kotrot] ADD CONSTRAINT [T02Kotrot$PK] PRIMARY KEY ([kotRaz])
GO
CREATE NONCLUSTERED INDEX [T02Kotrot$ix_sug] ON [dbo].[T02Kotrot] ([kotSug])
GO
CREATE NONCLUSTERED INDEX [T02Kotrot$ix_asm] ON [dbo].[T02Kotrot] ([kotASm])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T02Kotrot$ix_UQasmsug] ON [dbo].[T02Kotrot] ([kotSug], [kotASm])
GO
CREATE NONCLUSTERED INDEX [T02Kotrot$ix_heshbon] ON [dbo].[T02Kotrot] ([kotMsHeshbon])
GO
--CREATE NONCLUSTERED INDEX [T02Kotrot$ix_kotCustomerNum] ON [dbo].[T02Kotrot] ([kotCustomerNum])
--GO
--CREATE NONCLUSTERED INDEX [T02Kotrot$ix_kotID] ON [dbo].[T02Kotrot] ([kotID])
--GO
--CREATE NONCLUSTERED INDEX [T02Kotrot$ix_kotPatuah] ON [dbo].[T02Kotrot] ([kotPatuah])
--GO
--CREATE NONCLUSTERED INDEX [T02Kotrot$ix_kotPriority] ON [dbo].[T02Kotrot] ([kotPriority])
--GO
--CREATE NONCLUSTERED INDEX [T02Kotrot$ix_rskKodRofe] ON [dbo].[T02Kotrot] ([KodRofe])
--GO
--CREATE NONCLUSTERED INDEX [T02Kotrot$ix_rskMeupal] ON [dbo].[T02Kotrot] ([KotMetupal])
--GO
CREATE NONCLUSTERED INDEX [T02Kotrot$ix_Sohen] ON [dbo].[T02Kotrot] ([kotMsSohen]) WHERE [kotMsSohen] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T02Kotrot$ix_tarich] ON [dbo].[T02Kotrot] ([kotTarich]) WHERE [kotTarich] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T02Kotrot@ix_OpenTm]
	ON [dbo].[T02Kotrot] ([kotPatuah], [kotSug])
	INCLUDE ([kotASm], [kotMsHeshbon], [kotTarich], [kotErech])
	WHERE [kotSug] = N'תמ' AND [kotPatuah] = 0
GO

--38: Table T02KotrotMishneLabel
CREATE TABLE [dbo].[T02KotrotMishneLabel]
([kotsCounter] int IDENTITY(1, 1) NOT NULL,
 [kotsLabel] nvarchar(50) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02KotrotMishneLabel] ADD CONSTRAINT [T02KotrotMishneLabel$PK] PRIMARY KEY ([kotsCounter])
GO

--39: Table T02KotrotMishneText
CREATE TABLE [dbo].[T02KotrotMishneText]
([kottAsm] int NOT NULL,
 [kottSug] nvarchar(3) NOT NULL,
 [kottLabel] int DEFAULT (0) NOT NULL,
 [kottFreeText] nvarchar(200) NULL,
 [EmailSentTime] datetime NULL,
 [SmsSentTime] datetime NULL,
 [rv] rowversion NOT NULL
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [T02KotrotMishneText$ix_triple] ON [dbo].[T02KotrotMishneText] ([kottSug], [kottAsm], [kottLabel])
GO

--40: Table T02Miun
CREATE TABLE [dbo].[T02Miun]
([kmnKod] nvarchar(5) NOT NULL,
 [kmnTeur] nvarchar(50) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02Miun] ADD CONSTRAINT [T02Miun$PK] PRIMARY KEY ([kmnKod])
GO

--41: Table T02mlyPaturHaiav
CREATE TABLE [dbo].[T02mlyPaturHaiav]
([mlnAsm] int NULL,
 [mlnSug] nvarchar(3) NULL,
 [mlnShura] int NULL,
 [mlnPatur] float DEFAULT (0) NULL,
 [mlnHaiav] float DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO

--42: Table T02mlyPritimNilvim
CREATE TABLE [dbo].[T02mlyPritimNilvim]
([mlnAsm] int NOT NULL,
 [mlnSug] nvarchar(3) NOT NULL,
 [mlnShura] int NOT NULL,
 [mlnMakat1] nvarchar(24) NULL,
 [mlnKamut1] float DEFAULT (0) NULL,
 [mlnMakat2] nvarchar(24) NULL,
 [mlnKamut2] float DEFAULT (0) NULL,
 [mlnMakat3] nvarchar(24) NULL,
 [mlnKamut3] float DEFAULT (0) NULL,
 [mlnMakat4] nvarchar(24) NULL,
 [mlnKamut4] float DEFAULT (0) NULL,
 [mlnMakat5] nvarchar(24) NULL,
 [mlnKamut5] float DEFAULT (0) NULL,
 [mlnMakat6] nvarchar(24) NULL,
 [mlnKamut6] float DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02mlyPritimNilvim] ADD CONSTRAINT [T02mlyPritimNilvim$PK] PRIMARY KEY ([mlnAsm],[mlnSug],[mlnShura])
GO

--43: Table T02mlyShurot
CREATE TABLE [dbo].[T02mlyShurot]
([mlyShurotCounter] int IDENTITY(1, 1) NOT NULL,
 [mlyMisparParit] nvarchar(24) NULL,
 [mlySagur] bit DEFAULT (0) NOT NULL,
 [mlySugReshuma] nvarchar(3) NULL,
 [mlyAsm1] int NULL,
 [mlyMsShura] smallint NULL,
 [mlyMsHeshbon] int NULL,
 [mlyMahsan] nvarchar(3) NULL, --smallint NULL,
 [mlyTarich] datetime NULL,
 [mlyKamut] float NULL,
 [mlySugIdkun] varchar(1) NULL,
 [mlyMehir] money NULL,
 [mlyAhuz] Decimal(8,4) DEFAULT (0) NULL,
 [mlyTotalShura] money NULL, --int NULL,
 [mlyKodMatbea] nvarchar(2) NULL,
 [mlyMhirMatbea] money DEFAULT (0) NULL,
 [mlySugAsmMakor] nvarchar(3) NULL,
 [mlyMsAsmMakor] int NULL,
 [mlyMsShuraMakor] smallint NULL,
 [mlyKamutBefoal] float NULL,
 [mlySugAsmYaad] nvarchar(3) NULL,
 [mlyMsAsmYaad] int NULL, --nvarchar(7) NULL,
 [mlyMsShuraYaad] smallint NULL,
 [mlyStatusShura] nvarchar(3) NULL,
 [mlyMsSochen] int NULL,
 [mlyMsProject] nvarchar(24) NULL,
 [mlyIshur] bit DEFAULT (0) NOT NULL,
 [mlyMemo] nvarchar(max) NULL,
 [mlyNo] bit DEFAULT (0) NOT NULL,
 [mlyShar] float DEFAULT (1) NULL,
 [mlyKesher] nvarchar(250) NULL,
 [mlySaifProj] nvarchar(20) NULL,
 [mlySerial] nvarchar(50) NULL,
 [mlyNilve] int NULL,
 [mlyDateDelivery] datetime NULL,
 [mlyMehirWDisc] money NULL,
 [mlyMaam] money NULL,
 [mlyMehirWDiscWMaam] money NULL,
 [mlyTotWMaam] money NULL,
 [mlyErech] datetime NULL,
 [mlyDamageLost] nvarchar(1) NULL,
 [mlyDaysHachzara] float NULL,
 [mlyCostDamage] money NULL,
 [mlyKamutReturned] float NULL,
 [mlyLastPeriodCharge] money NULL,
 [mlyLastDaysCharge] float NULL,
 [mlyCurrentPeriodPriceEnd] money NULL,
 [mlyCurrentPeriodPriceStart] money NULL,
 [mlyCurrentDaysPrice] money NULL,
 [mlyCurrentDays] float NULL,
 [mlyNumShinaim] nvarchar(200) NULL,
 [mlyDateRentStart] datetime NULL,
 [mlyIsMissing] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02mlyShurot] ADD CONSTRAINT [T02mlyShurot$PK] PRIMARY KEY ([mlyShurotCounter])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T02mlyShurot$ix_triple] ON [dbo].[T02mlyShurot] ([mlySugReshuma], [mlyAsm1], [mlyMsShura]) WHERE [mlySugReshuma] IS NOT NULL AND [mlyAsm1] IS NOT NULL AND [mlyMsShura] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T02mlyShurot$ix_SugAsm1] ON [dbo].[T02mlyShurot] ([mlySugReshuma], [mlyAsm1]) WHERE [mlySugReshuma] IS NOT NULL AND [mlyAsm1] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T02mlyShurot$ix_asm] ON [dbo].[T02mlyShurot] ([mlyAsm1]) WHERE [mlyAsm1] IS NOT NULL
--GO
--CREATE NONCLUSTERED INDEX [T02mlyShurot$ix_mahsan] ON [dbo].[T02mlyShurot] ([mlyMahsan]) WHERE [mlyMahsan] IS NOT NULL
--GO
--CREATE NONCLUSTERED INDEX [T02mlyShurot$ix_makor2Flds] ON [dbo].[T02mlyShurot] ([mlyMsAsmMakor], [mlyMsShuraMakor])
--GO
CREATE NONCLUSTERED INDEX [T02mlyShurot$ix_makorThreeFlds] ON [dbo].[T02mlyShurot] ([mlySugAsmMakor], [mlyMsAsmMakor], [mlyMsShuraMakor]) WHERE [mlySugAsmMakor] IS NOT NULL AND [mlyMsAsmMakor] IS NOT NULL AND [mlyMsShuraMakor] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T02mlyShurot$ix_makorTwoFlds] ON [dbo].[T02mlyShurot] ([mlySugAsmMakor], [mlyMsAsmMakor]) WHERE [mlySugAsmMakor] IS NOT NULL AND [mlyMsAsmMakor] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T02mlyShurot$ix_mlyIsMissing] ON [dbo].[T02mlyShurot] ([mlyIsMissing])
--GO
--CREATE NONCLUSTERED INDEX [T02mlyShurot$ix_mlySugAsmMakor] ON [dbo].[T02mlyShurot] ([mlySugAsmMakor])
--GO
CREATE NONCLUSTERED INDEX [T02mlyShurot$ix_parit] ON [dbo].[T02mlyShurot] ([mlyMisparParit]) WHERE [mlyMisparParit] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T02mlyShurot$ix_SugIdkun12Incl]
	ON [dbo].[T02mlyShurot] ([mlySugIdkun])
	INCLUDE ([mlyMisparParit],[mlyMahsan],[mlyKamut]) WHERE [mlySugIdkun] IN ('1', '2')
GO


--44: Table T02mlyShurotSgira
CREATE TABLE [dbo].[T02mlyShurotSgira]
([mlsCounter] int NOT NULL,
 [mlsAsm] int NULL,
 [mlsSug] nvarchar(3) NULL,
 [mlsHuzman] int NULL,
 [mlsNow] int NULL,
 [mlsSapak] int NULL,
 [mlsIshur] bit DEFAULT (0) NOT NULL,
 [mlsSagur] bit DEFAULT (0) NOT NULL,
 [mlsAsm2] int NULL,
 [mlsSug2] nvarchar(3) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02mlyShurotSgira] ADD CONSTRAINT [T02mlyShurotSgira$PK] PRIMARY KEY ([mlsCounter])
GO

--45: Table T02mlyShurotYehida
CREATE TABLE [dbo].[T02mlyShurotYehida]
([mlCounter] int NOT NULL,
 [mlAsm] int NULL,
 [mlSug] nvarchar(3) NULL,
 [mlYehidot] float DEFAULT (0) NULL,
 [mlOrech] float DEFAULT (0) NULL,
 [mlRohav] float DEFAULT (0) NULL,
 [mlOvi] float DEFAULT (0) NULL,
 [mlMida] nvarchar(2) NULL,
 [mlMishkal] float DEFAULT (0) NULL,
 [mlSapak] int NULL,
 [mlNegdi] nvarchar(50) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02mlyShurotYehida] ADD CONSTRAINT [T02mlyShurotYehida$PK] PRIMARY KEY ([mlCounter])
GO

--46: Table T02ShurotKishurFormat
CREATE TABLE [dbo].[T02ShurotKishurFormat]
([frtMsLabel] int DEFAULT (0) NULL,
 [frtSugMismah] nvarchar(4) NULL,
 [frtMsShura] int DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO

--47: Table T02ShurotShva
CREATE TABLE [dbo].[T02ShurotShva]
([TnfCounter] int NOT NULL,
 [shvMsKartisAshrayAroch] nvarchar(50) NULL,
 [shvMsKartisAshrayKazar] nvarchar(20) NULL,
 [TrTokef] varchar(4) NULL,
 [shvSchum] money DEFAULT (0) NULL,
 [shvSugIska] smallint DEFAULT (0) NULL,
 [shvSugAshray] smallint DEFAULT (0) NULL,
 [shvKodIska] smallint DEFAULT (0) NULL,
 [shvSugMatbea] smallint DEFAULT (0) NULL,
 [shvMsTashlumim] smallint DEFAULT (0) NULL,
 [shvSchumTashlumRishon] money DEFAULT (0) NULL,
 [shvSchumTashlumKavua] money DEFAULT (0) NULL,
 [shvMsIshur] int DEFAULT (0) NULL,
 [shvSwShidur] bit DEFAULT (0) NOT NULL,
 [shvMsIska] int NULL,
 [shvIskaCounter] int NULL,
 [shvAnswer] int NULL,
 [shvAllCounter] int IDENTITY(1, 1) NOT NULL,
 [shvCVV2] varchar(4) NULL,
 [shvWhyNotCVV2] tinyint NULL,
 [shvZehut] varchar(9) NULL,
 [sug] varchar(3) NULL,
 [tempAsm] int NULL,
 [asm] int NULL,
 [customerNum] int NULL,
 [theDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [theTime] datetime DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) NULL,
 [idRecharge] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02ShurotShva] ADD CONSTRAINT [T02ShurotShva$PK] PRIMARY KEY ([shvAllCounter])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T02ShurotShva$ix_TnfCounter] ON [dbo].[T02ShurotShva] ([TnfCounter])
GO
--CREATE NONCLUSTERED INDEX [T02ShurotShva$ix_comb] ON [dbo].[T02ShurotShva] ([shvMsIska],[shvAllCounter])
--GO
--CREATE NONCLUSTERED INDEX [T02ShurotShva$ix_idRecharge] ON [dbo].[T02ShurotShva] ([idRecharge])
--GO
--CREATE NONCLUSTERED INDEX [T02ShurotShva$ix_shvMsIska] ON [dbo].[T02ShurotShva] ([shvMsIska])
--GO
--CREATE NONCLUSTERED INDEX [T02ShurotShva$ix_theDateTime] ON [dbo].[T02ShurotShva] ([theDate],[theTime])
--GO

--48: Table T02Sugim
CREATE TABLE [dbo].[T02Sugim]
([sgmSugMismach] nvarchar(3) NOT NULL,
 [sgmTeurMismach] nvarchar(40) NULL,
 [sgmStarter] int NULL,
 [sgmLast] int NULL,
 [sgmZmani] int DEFAULT (0) NULL,
 [sgmOtakim] tinyint NULL,
 [sgmKod1] tinyint NULL,
 [sgmKod2] tinyint NULL,
 [sgmKod3] tinyint NULL,
 [sgmMll1] tinyint NULL,
 [sgmMll2] tinyint NULL,
 [sgmIgul] tinyint NULL,
 [sgmKod] tinyint NULL,
 [sgmKodPratim] int NULL,
 [sgmPrintDoc] tinyint DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02Sugim] ADD CONSTRAINT [T02Sugim$PK] PRIMARY KEY ([sgmSugMismach])
GO
--CREATE NONCLUSTERED INDEX [T02Sugim$ix_sgmIgul] ON [dbo].[T02Sugim] ([sgmIgul])
--GO
--CREATE NONCLUSTERED INDEX [T02Sugim$ix_sgmTeurMismach] ON [dbo].[T02Sugim] ([sgmTeurMismach])
--GO

--49: Table T02SugimShivuk
CREATE TABLE [dbo].[T02SugimShivuk]
([shCounter] int IDENTITY(1, 1) NOT NULL,
 [shSugMismah] nvarchar(3) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02SugimShivuk] ADD CONSTRAINT [T02SugimShivuk$PK] PRIMARY KEY ([shCounter])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T02SugimShivuk$ix_UQ_Sug] ON [dbo].[T02SugimShivuk] ([shSugMismah])
GO

--50: Table T02TmYadani
CREATE TABLE [dbo].[T02TmYadani]
([tmAsm] int NOT NULL,
 [tmMsHeshbon] int NULL,
 [tmTarich] datetime NULL,
 [tmSchum] money DEFAULT (0) NULL,
 [tmIshur] bit DEFAULT (0) NOT NULL,
 [tmSagur] bit DEFAULT (0) NOT NULL,
 [tmPratim] nvarchar(max) NULL,
 [tmMakat] nvarchar(24) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02TmYadani] ADD CONSTRAINT [T02TmYadani$PK] PRIMARY KEY ([tmAsm])
GO

--51: Table T02yehidot
CREATE TABLE [dbo].[T02yehidot]
([yemKodMida] int IDENTITY(1, 1) NOT NULL,
 [yemTeurMida] nvarchar(20) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02yehidot] ADD CONSTRAINT [T02yehidot$PK] PRIMARY KEY ([yemKodMida])
GO

--52: Table T02YtrotMly
CREATE TABLE [dbo].[T02YtrotMly]
([ymlCounter] int IDENTITY(1, 1) NOT NULL,
 [ymlMahsan] nvarchar(3) NOT NULL,
 [ymlMsParit] nvarchar(24) NOT NULL,
 [ymlYtra] float DEFAULT (0) NULL,
 [ymlTotKnisot] int DEFAULT (0) NULL,
 [ymlTotYeziot] int DEFAULT (0) NULL,
 [ymlMehirPtiha] money NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T02YtrotMly] ADD CONSTRAINT [T02YtrotMly$PK] PRIMARY KEY ([ymlCounter])
GO
--CREATE NONCLUSTERED INDEX [T02YtrotMly$ix_ymlMahsan] ON [dbo].[T02YtrotMly] ([ymlMahsan], [ymlMsParit])
--GO
CREATE UNIQUE NONCLUSTERED INDEX [T02YtrotMly$ix_ymlMsParit] ON [dbo].[T02YtrotMly] ([ymlMahsan], [ymlMsParit])
GO
--CREATE NONCLUSTERED INDEX [T02YtrotMly$ix_ytra] ON [dbo].[T02YtrotMly] ([ymlYtra])
--GO
--CREATE NONCLUSTERED INDEX [T02YtrotMly$ix_sugIdkunInclude] ON [dbo].[T02mlyShurot] ([mlySugIdkun])
--	INCLUDE ([mlyMisparParit], [mlyMahsan], [mlyKamut])
--GO
--DROP INDEX [T02YtrotMly$ix_sugIdkunInclude] ON [dbo].[T02mlyShurot]
--GO

--53: Table T03hanahot
CREATE TABLE [dbo].[T03hanahot]
([hanKodTavla] int DEFAULT (0) NULL,
 [hanIfun1] nvarchar(3) NULL,
 [hanIfun2] nvarchar(3) NULL,
 [hanIfun3] nvarchar(3) NULL,
 [hanAhuz] real DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO

--54: Table T03MakatSapak
CREATE TABLE [dbo].[T03MakatSapak]
([psMakat] nvarchar(24) NOT NULL,
 [psSapak] int NOT NULL,
 [psMakatNegdi] nvarchar(24) NULL,
 [psMehir] money DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
--ALTER TABLE [dbo].[T03MakatSapak] ADD CONSTRAINT [T03MakatSapak$PK] PRIMARY KEY ([psMakat],[psSapak])
--GO

--55: Table T03MakatYazran
CREATE TABLE [dbo].[T03MakatYazran]
([yzKodYazran] int NOT NULL,
 [yzMsParit] nvarchar(24) NOT NULL,
 [yzMakatYazran] nvarchar(24) NULL,
 [rv] rowversion NOT NULL
)
GO
--ALTER TABLE [dbo].[T03MakatYazran] ADD CONSTRAINT [T03MakatYazran$PK] PRIMARY KEY ([yzKodYazran],[yzMsParit])
--GO

--56: Table T03MechironKamut
CREATE TABLE [dbo].[T03MechironKamut]
([mhkNumber] int NOT NULL,
 [mhkMsParit] nvarchar(24) NOT NULL,
 [mhkAdKamut] float DEFAULT (0) NOT NULL,
 [mhkMehir] money DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
--ALTER TABLE [dbo].[T03MechironKamut] ADD CONSTRAINT [T03MechironKamut$PK] PRIMARY KEY ([mhkNumber],[mhkMsParit],[mhkAdKamut])
--GO

--57: Table T03Mehirim
CREATE TABLE [dbo].[T03Mehirim]
([mhrCounter] int IDENTITY(1, 1) NOT NULL,
 [mhrMispar] int DEFAULT (0) NULL,
 [mhrMsParit] nvarchar(24) NULL,
 [mhrKodMatbea] nvarchar(2) NULL,
 [mhrKodMehir] tinyint NULL,
 [mhrMehir] int NULL,
 [mhrAhuz] Decimal(4,0) DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
--ALTER TABLE [dbo].[T03Mehirim] ADD CONSTRAINT [T03Mehirim$PK] PRIMARY KEY ([mhrCounter])
--GO

--58: Table T03Mehironim
CREATE TABLE [dbo].[T03Mehironim]
([ronCounter] int IDENTITY(1, 1) NOT NULL,
 [ronMsMehiron] int NULL,
 [ronMsKatalogi] nvarchar(24) NULL,
 [ronBetokefMeTarich] datetime NULL,
 [ronMehirYhudi] money NULL,
 [ronAhuzYhudi] Decimal(8,4) NULL,
 [ronMsKatalogiNegdi] nvarchar(24) NULL,
 [ronBetokef] bit DEFAULT (0) NOT NULL,
 [ronMatbea] nvarchar(50) NULL,
 [ronSugMehir] nvarchar(16) NULL,
 [ronHovala] nvarchar(6) NULL,
 [ronHamasa] float DEFAULT (0) NULL,
 [ronChanged] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T03Mehironim] ADD CONSTRAINT [T03Mehironim$PK] PRIMARY KEY ([ronCounter])
GO
CREATE NONCLUSTERED INDEX [T03Mehironim$ix_ronMsMehiron] ON [dbo].[T03Mehironim] ([ronMsMehiron]) WHERE [ronMsMehiron] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T03Mehironim$ix_combo] ON [dbo].[T03Mehironim] ([ronMsMehiron], [ronMsKatalogi]) WHERE [ronMsMehiron] IS NOT NULL AND [ronMsKatalogi] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T03Mehironim$ix_ronBetokefMeTarich] ON [dbo].[T03Mehironim] ([ronBetokefMeTarich])
--GO
--CREATE NONCLUSTERED INDEX [T03Mehironim$ix_ronMsKatalogi] ON [dbo].[T03Mehironim] ([ronMsKatalogi])
--GO
CREATE NONCLUSTERED INDEX [T03Mehironim$ix_ronSugMehir] ON [dbo].[T03Mehironim] ([ronSugMehir]) WHERE [ronSugMehir] IS NOT NULL
GO

--59: Table T03MehironimOld
CREATE TABLE [dbo].[T03MehironimOld]
([ronCounter] int IDENTITY(1, 1) NOT NULL,
 [ronMsMehiron] int NULL,
 [ronMsKatalogi] nvarchar(24) NULL,
 [ronBetokefMeTarich] datetime NULL,
 [ronMehirYhudi] money NULL,
 [ronAhuzYhudi] Decimal(6,2) NULL,
 [ronMsKatalogiNegdi] nvarchar(24) NULL,
 [ronBetokef] bit DEFAULT (0) NOT NULL,
 [ronMatbea] nvarchar(50) NULL,
 [ronDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T03MehironimOld] ADD CONSTRAINT [T03MehironimOld$PK] PRIMARY KEY ([ronCounter])
GO
CREATE NONCLUSTERED INDEX [T03MehironimOld$ix_combo] ON [dbo].[T03MehironimOld] ([ronMsMehiron], [ronMsKatalogi]) WHERE [ronMsMehiron] IS NOT NULL AND [ronMsKatalogi] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T03MehironimOld$ix_ronBetokefMeTarich] ON [dbo].[T03MehironimOld] ([ronBetokefMeTarich])
--GO
--CREATE NONCLUSTERED INDEX [T03MehironimOld$ix_ronMsKatalogi] ON [dbo].[T03MehironimOld] ([ronMsKatalogi])
--GO
--CREATE NONCLUSTERED INDEX [T03MehironimOld$ix_ronMsMehiron] ON [dbo].[T03MehironimOld] ([ronMsMehiron])
--GO

--60: Table T03RamotMehir
CREATE TABLE [dbo].[T03RamotMehir]
([rmCounter] int IDENTITY(1, 1) NOT NULL,
 [rmSugMehir] nvarchar(1) NULL,
 [rmAhuz] float DEFAULT (0) NULL,
 [rmSiman] varchar(1) NULL,
 [rv] rowversion NOT NULL
)
GO
--ALTER TABLE [dbo].[T03RamotMehir] ADD CONSTRAINT [T03RamotMehir$PK] PRIMARY KEY ([rmCounter])
--GO

--61: Table T03SapakimNivhar
CREATE TABLE [dbo].[T03SapakimNivhar]
([spMsHeshbon] int NULL,
 [spKazar] nvarchar(3) NULL,
 [rv] rowversion NOT NULL
)
GO
--ALTER TABLE [dbo].[T03SapakimNivhar] ADD CONSTRAINT [T03SapakimNivhar$PK] PRIMARY KEY ([spMsHeshbon])
--GO
--CREATE UNIQUE NONCLUSTERED INDEX [T03SapakimNivhar$ix_spKazar] ON [dbo].[T03SapakimNivhar] ([spKazar])
--GO

--62: Table T03SfiraKoteret
CREATE TABLE [dbo].[T03SfiraKoteret]
([sfkCounter] int IDENTITY(1, 1) NOT NULL,
 [sfkMahsan] nvarchar(3) DEFAULT (N'1') NULL,
 [sfkOved] int NULL,
 [sfkTeur] nvarchar(100) NULL,
 [sfkDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [sfkSagur] bit DEFAULT (0) NOT NULL,
 [sfkPrimary] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T03SfiraKoteret] ADD CONSTRAINT [T03SfiraKoteret$PK] PRIMARY KEY ([sfkCounter])
GO

--63: Table T03SfiraShurot
CREATE TABLE [dbo].[T03SfiraShurot]
([sfsNumber] int NOT NULL,
 [sfsMsParit] nvarchar(24) NOT NULL,
 [sfsKamut] float NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T03SfiraShurot] ADD CONSTRAINT [T03SfiraShurot$PK] PRIMARY KEY ([sfsNumber], [sfsMsParit])
GO

--64: Table T03TeurMehirim
CREATE TABLE [dbo].[T03TeurMehirim]
([tmhMehironClali] int NULL,
 [tmhTeurMehironClali] nvarchar(20) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
--ALTER TABLE [dbo].[T03TeurMehirim] ADD CONSTRAINT [T03TeurMehirim$PK] PRIMARY KEY ([tmhMehironClali])
--GO

--65: Table T03TeurMehiron
CREATE TABLE [dbo].[T03TeurMehiron]
([temMsMehiron] int NOT NULL,
 [temTeurMehironYhudi] nvarchar(40) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T03TeurMehiron] ADD CONSTRAINT [T03TeurMehiron$PK] PRIMARY KEY ([temMsMehiron])
GO

--66: Table T03TmplKamut
CREATE TABLE [dbo].[T03TmplKamut]
([tmplAdKamut] float DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO

--67: Table T05Bags
CREATE TABLE [dbo].[T05Bags]
([idBag] int IDENTITY(1, 1) NOT NULL,
 [dtBag] datetime DEFAULT (GETDATE()) NULL,
 [lakBag] int NOT NULL,
 [comBag] nvarchar(254) NULL,
 [dtDelivery] datetime NULL,
 [KodRofeBag] int NULL,
 [BagEmailSentTime] datetime NULL,
 [BagSmsSentTime] datetime NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Bags] ADD CONSTRAINT [T05Bags$PK] PRIMARY KEY ([idBag])
GO
CREATE NONCLUSTERED INDEX [T05Bags$ix_lakBag] ON [dbo].[T05Bags] ([lakBag])
GO

--68: Table T05BagsHazs
CREATE TABLE [dbo].[T05BagsHazs]
([idBag] int NULL,
 [numHaz] int NULL,
 [autonums] int IDENTITY(1, 1) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05BagsHazs] ADD CONSTRAINT [T05BagsHazs$PK] PRIMARY KEY ([autonums])
GO
CREATE NONCLUSTERED INDEX [T05BagsHazs$ix_idBag] ON [dbo].[T05BagsHazs] ([idBag]) WHERE [idBag] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T05BagsHazs$ix_numHaz] ON [dbo].[T05BagsHazs] ([numHaz]) WHERE [numHaz] IS NOT NULL
GO

--69: Table T05Bakara
CREATE TABLE [dbo].[T05Bakara]
([ComboLakoahInHazmanotSort] int DEFAULT (0) NULL,
 [ComboShlavAvodaInAzmanotKoteret] int DEFAULT (0) NULL
)
GO

--70: Table T05BoxesLastNums
CREATE TABLE [dbo].[T05BoxesLastNums]
([ID_Row] tinyint NOT NULL,
 [SP_LastNum] smallint NULL,
 [SP_LastDay] tinyint NULL,
 [Z_LastNum] smallint NULL,
 [Z_LastDay] tinyint NULL,
 [NP_LastNum] smallint NULL,
 [NP_LastTrgFldr] tinyint NULL
)
GO
ALTER TABLE [dbo].[T05BoxesLastNums] ADD CONSTRAINT [T05BoxesLastNums$PK] PRIMARY KEY ([ID_Row])
GO

--71: Table T05Colors
CREATE TABLE [dbo].[T05Colors]
([clrNum] nvarchar(15) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Colors] ADD CONSTRAINT [T05Colors$PK] PRIMARY KEY ([clrNum])
GO

--72: Table T05CurRonShlihim
CREATE TABLE [dbo].[T05CurRonShlihim]
([rnsNumShaliah] int NOT NULL,
 [rnsNumLakoah] int NOT NULL,
 [rnsMehir] money NULL,
 [rnsMehirDouble] money NULL,
 [rnsDateTime] datetime DEFAULT (GETDATE()) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05CurRonShlihim] ADD CONSTRAINT [T05CurRonShlihim$PK] PRIMARY KEY ([rnsNumShaliah], [rnsNumLakoah])
GO

--73: Table T05OldRonShlihim
CREATE TABLE [dbo].[T05OldRonShlihim]
([orsNumShaliah] int NULL,
 [orsNumLakoah] int NULL,
 [orsMehir] money NULL,
 [orsMehirDouble] money NULL,
 [orsDateTime] datetime NULL,
 [rv] rowversion NOT NULL
)
GO

--74: Table T05DlvOrders
CREATE TABLE [dbo].[T05DlvOrders]
([id] int IDENTITY(1, 1) NOT NULL,
 [DLVdocAsm] int NULL,
 [numHazmana] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05DlvOrders] ADD CONSTRAINT [T05DlvOrders$PK] PRIMARY KEY ([id])
GO
CREATE NONCLUSTERED INDEX [T05DlvOrders$ix_av] ON [dbo].[T05DlvOrders] ([DLVdocAsm])
GO
CREATE NONCLUSTERED INDEX [T05DlvOrders$ix_ben] ON [dbo].[T05DlvOrders] ([numHazmana])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T05DlvOrders$ix_uq_AvBen] ON [dbo].[T05DlvOrders] ([DLVdocAsm], [numHazmana])
GO

--75: Table T05Madbeka
CREATE TABLE [dbo].[T05Madbeka]
([mdbNumMadbeka] int NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Madbeka] ADD CONSTRAINT [T05Madbeka$PK] PRIMARY KEY ([mdbNumMadbeka])
GO

--76: Table T05MadbekaDetails
CREATE TABLE [dbo].[T05MadbekaDetails]
([mddNumMadbeka] int NULL,
 [mddMetalCode] nvarchar(10) NULL,
 [mddAhuz] Decimal(6,2) DEFAULT (0) NULL,
 [mddAuto] int IDENTITY(1, 1) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05MadbekaDetails] ADD CONSTRAINT [T05MadbekaDetails$PK] PRIMARY KEY ([mddAuto])
GO
CREATE NONCLUSTERED INDEX [T05MadbekaDetails$ix_mddMetalCode] ON [dbo].[T05MadbekaDetails] ([mddMetalCode]) WHERE [mddMetalCode] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T05MadbekaDetails$ix_mddNumMadbeka] ON [dbo].[T05MadbekaDetails] ([mddNumMadbeka]) WHERE [mddNumMadbeka] IS NOT NULL
GO

--77: Table T05Mahlakot
CREATE TABLE [dbo].[T05Mahlakot]
([mhkCntMahlaka] int IDENTITY(1, 1) NOT NULL,
 [mhkKodMahlaka] nvarchar(4) NOT NULL,
 [mhkTeurMaklaha] nvarchar(20) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Mahlakot] ADD CONSTRAINT [T05Mahlakot$PK] PRIMARY KEY ([mhkCntMahlaka])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T05Mahlakot$ix_rslKodShlav] ON [dbo].[T05Mahlakot] ([mhkKodMahlaka])
GO

--78: Table T05MahlakaOvdim
CREATE TABLE [dbo].[T05MahlakaOvdim]
([mhkovCnt] int IDENTITY(1, 1) NOT NULL,
 [mhkovKodMahlaka] nvarchar(4) NOT NULL,
 [mhkovKodOved] tinyint NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05MahlakaOvdim] ADD CONSTRAINT [T05MahlakaOvdim$PK] PRIMARY KEY ([mhkovCnt])
GO

--79: Table T05MahlakaShlavim
CREATE TABLE [dbo].[T05MahlakaShlavim]
([mhslCnt] int IDENTITY(1, 1) NOT NULL,
 [mhslKodMahlaka] nvarchar(4) NOT NULL,
 [mhslKodShlav] nvarchar(4) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05MahlakaShlavim] ADD CONSTRAINT [T05MahlakaShlavim$PK] PRIMARY KEY ([mhslCnt])
GO

--80: Table T05MakavSpecial
CREATE TABLE [dbo].[T05MakavSpecial]
([id] int IDENTITY(1, 1) NOT NULL,
 [NumLak] int NULL,
 [NumRofe] int NULL,
 [NameMetupal] nvarchar(30) NULL,
 [NumHazmana] int NULL,
 [txtComment] nvarchar(255) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05MakavSpecial] ADD CONSTRAINT [T05MakavSpecial$PK] PRIMARY KEY ([id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T05MakavSpecial$ix_NumHazmana] ON [dbo].[T05MakavSpecial] ([NumHazmana]) WHERE [NumHazmana] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T05MakavSpecial$ix_LakMetupal] ON [dbo].[T05MakavSpecial] ([NumLak], [NameMetupal]) WHERE [NumLak] IS NOT NULL AND [NameMetupal] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T05MakavSpecial$ix_LakRofeMetupal] ON [dbo].[T05MakavSpecial] ([NumLak], [NumRofe], [NameMetupal]) WHERE [NumLak] IS NOT NULL AND [NumRofe] IS NOT NULL AND [NameMetupal] IS NOT NULL
GO

--81: Table T05Metals
CREATE TABLE [dbo].[T05Metals]
([mtlCode] nvarchar(10) NOT NULL,
 [mtlName] nvarchar(18) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Metals] ADD CONSTRAINT [T05Metals$PK] PRIMARY KEY ([mtlCode])
GO

--82: Table T05Metupalim
CREATE TABLE [dbo].[T05Metupalim]
([rspMisMetupal] int IDENTITY(1, 1) NOT NULL,
 [rspShemMetupal] nvarchar(30) NOT NULL,
 [rspMsZehuy] varchar(9) NULL,
 [rspMsIshi] int NULL,
 [rspKtovetMetupal] nvarchar(30) NULL,
 [rspTelFonMetupal] nvarchar(12) NULL,
 [rspTarihLida] datetime NULL,
 [rspMinMetupal] nvarchar(1) CHECK(rspMinMetupal = 'נ' Or rspMinMetupal = 'ז') NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Metupalim] ADD CONSTRAINT [T05Metupalim$PK] PRIMARY KEY ([rspMisMetupal])
GO
CREATE NONCLUSTERED INDEX [T05Metupalim$ix_rskShemMetupal] ON [dbo].[T05Metupalim] ([rspShemMetupal])
GO

--83: Table T05Michsot
CREATE TABLE [dbo].[T05Michsot]
([mchMsOved] int NOT NULL,
 [mchKodShlav] nvarchar(4) NOT NULL,
 [mchKamut] smallint NULL,
 [mchKamutTemp] smallint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Michsot] ADD CONSTRAINT [T05Michsot$PK] PRIMARY KEY ([mchMsOved], [mchKodShlav])
GO
CREATE NONCLUSTERED INDEX [T05Michsot$ix_MsOved] ON [dbo].[T05Michsot] ([mchMsOved])
GO
CREATE NONCLUSTERED INDEX [T05Michsot$ix_rslKodShlav] ON [dbo].[T05Michsot] ([mchKodShlav])
GO

--84: Table T05OrdersAbroadList
CREATE TABLE [dbo].[T05OrdersAbroadList]
([abrRaz] int IDENTITY(1, 1) NOT NULL,
 [abrBatch] int NOT NULL,
 [abrFileName] nvarchar(255) NULL,
 [abrPath] nvarchar(255) NULL,
 [abrDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [abrTime] datetime DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05OrdersAbroadList] ADD CONSTRAINT [T05OrdersAbroadList$PK] PRIMARY KEY ([abrRaz])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T05OrdersAbroadList$ix_asm] ON [dbo].[T05OrdersAbroadList] ([abrBatch])
GO
CREATE NONCLUSTERED INDEX [T05OrdersAbroadList$ix_tarich] ON [dbo].[T05OrdersAbroadList] ([abrDate])
GO

--85: Table T05ParitShlavim
CREATE TABLE [dbo].[T05ParitShlavim]
([pshAutoCntr] int IDENTITY(1, 1) NOT NULL,
 [pshMKT] nvarchar(26) NOT NULL,
 [pshKodShlav] nvarchar(4) NOT NULL,
 [pshKodOved] tinyint NULL,
 [pshYamim] real NULL,
 [pshBchar] bit DEFAULT (0) NOT NULL,
 [pshOrdNum] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05ParitShlavim] ADD CONSTRAINT [T05ParitShlavim$PK] PRIMARY KEY ([pshAutoCntr])
GO
CREATE NONCLUSTERED INDEX [T05ParitShlavim$ix_pshMKT] ON [dbo].[T05ParitShlavim] ([pshMKT])
GO
CREATE NONCLUSTERED INDEX [T05ParitShlavim$ix_rslKodShlav] ON [dbo].[T05ParitShlavim] ([pshKodShlav])
GO
CREATE NONCLUSTERED INDEX [T05ParitShlavim$ix_pshKodOved] ON [dbo].[T05ParitShlavim] ([pshKodOved]) WHERE [pshKodOved] IS NOT NULL
GO

--86: Table T05Rofim
CREATE TABLE [dbo].[T05Rofim]
([rsrCounter] int NOT NULL,
 [rsrShem] nvarchar(100) NULL,
 [rsrTelefon] varchar(14) NULL,
 [rsrPelephone] varchar(12) NULL,
 [rsrMakomAvoda] nvarchar(30) NULL,
 [rsrHearotRofe] nvarchar(255) NULL,
 [doctorIdNum] varchar(10) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Rofim] ADD CONSTRAINT [T05Rofim$PK] PRIMARY KEY ([rsrCounter])
GO
CREATE NONCLUSTERED INDEX [T05Rofim$ix_IndShem] ON [dbo].[T05Rofim] ([rsrShem]) WHERE [rsrShem] IS NOT NULL
GO

--87: Table T05RofimLakoah
CREATE TABLE [dbo].[T05RofimLakoah]
([kshMsHeshbon] int NOT NULL,
 [kshMsRofe] int NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05RofimLakoah] ADD CONSTRAINT [T05RofimLakoah$PK] PRIMARY KEY ([kshMsHeshbon], [kshMsRofe])
GO

--88: Table T05RofPrefers
CREATE TABLE [dbo].[T05RofPrefers]
([rpfRofe] int NOT NULL,
 [rpfKodShlav] nvarchar(4) NOT NULL,
 [rpfKodOved] int NOT NULL,
 [rpfOrdNum] smallint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05RofPrefers] ADD CONSTRAINT [T05RofPrefers$PK] PRIMARY KEY ([rpfRofe], [rpfKodShlav], [rpfKodOved])
GO
CREATE NONCLUSTERED INDEX [T05RofPrefers$ix_rpfOrdNum] ON [dbo].[T05RofPrefers] ([rpfOrdNum])
GO

--89: Table T05RptMkdHist
CREATE TABLE [dbo].[T05RptMkdHist]
([id] int IDENTITY(1, 1) NOT NULL,
 [DohNum] int NOT NULL,
 [DohZman] datetime NULL,
 [DohSug] tinyint NULL,
 [numHaz] int NULL,
 [DohHeara] nvarchar(255) NULL,
 [ahuz] money NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05RptMkdHist] ADD CONSTRAINT [T05RptMkdHist$PK] PRIMARY KEY ([id])
GO
CREATE NONCLUSTERED INDEX [T05RptMkdHist$ix_DohNum] ON [dbo].[T05RptMkdHist] ([DohNum])
GO
CREATE NONCLUSTERED INDEX [T05RptMkdHist$ix_DohSug] ON [dbo].[T05RptMkdHist] ([DohSug])
GO
CREATE NONCLUSTERED INDEX [T05RptMkdHist$ix_numHaz] ON [dbo].[T05RptMkdHist] ([numHaz])
GO

--90: Table T05RptLinesMkdHist
CREATE TABLE [dbo].[T05RptLinesMkdHist]
([Counter] int IDENTITY(1, 1) NOT NULL,
 [DohNum] int NOT NULL,
 [DohZman] datetime NULL,
 [DohSug] tinyint NULL,
 [numHaz] int NULL,
 [numLine] int NULL,
 [DohHeara] nvarchar(255) NULL,
 [ahuz] money NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05RptLinesMkdHist] ADD CONSTRAINT [T05RptLinesMkdHist$PK] PRIMARY KEY ([Counter])
GO
CREATE NONCLUSTERED INDEX [T05RptLinesMkdHist$ix_DohNum] ON [dbo].[T05RptLinesMkdHist] ([DohNum])
GO
CREATE NONCLUSTERED INDEX [T05RptLinesMkdHist$ix_DohSug] ON [dbo].[T05RptLinesMkdHist] ([DohSug])
GO
CREATE NONCLUSTERED INDEX [T05RptLinesMkdHist$ix_numHaz] ON [dbo].[T05RptLinesMkdHist] ([numHaz])
GO
CREATE NONCLUSTERED INDEX [T05RptLinesMkdHist$ix_numHaz1] ON [dbo].[T05RptLinesMkdHist] ([numLine])
GO

--91: Table T05rvImportDeps
CREATE TABLE [dbo].[T05rvImportDeps]
([depNum] tinyint NOT NULL,
 [depDescr] nvarchar(60) NULL,
 [depPrintTypeNum] tinyint NULL,
 [depPrintQty] tinyint NULL,
 [depExitMethod] tinyint NULL,
 [depType] tinyint NULL,
 [GmarType] tinyint NULL,
 [MadbekaType] tinyint NULL,
 [GmarFolderPath] nvarchar(255) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05rvImportDeps] ADD CONSTRAINT [T05rvImportDeps$PK] PRIMARY KEY ([depNum])
GO
--CREATE NONCLUSTERED INDEX [T05rvImportDeps$ix_depPrintTypeNum] ON [dbo].[T05rvImportDeps] ([depPrintTypeNum])
--GO

--92: Table T05rvImportDtls
CREATE TABLE [dbo].[T05rvImportDtls]
([imdNum] int NOT NULL,
 [imdLak] int NULL,
 [imdMkt] nvarchar(24) NULL,
 [imdDep] tinyint NULL,
 [imdPatient] nvarchar(20) NULL,
 [imdTeeth] nvarchar(12) NULL,
 [imdQty] nvarchar(2) NULL,
 [imdColor] nvarchar(8) NULL,
 [imdFileCmmnt] nvarchar(16) NULL,
 [imdSrcFldrNum] tinyint NULL,
 [imdHzNum] int NULL,
 [imdKufsa] nvarchar(4) NULL,
 [imdImportDate] datetime NULL,
 [imdImportTime] datetime NULL,
 [imdIntrFldrNum] tinyint NULL,
 [imdTrgFldrNum] tinyint NULL,
 [imdFileCreationZman] datetime NULL,
 [imdOriginFileName] nvarchar(255) NULL,
 [imdLateFileName] nvarchar(255) NULL,
 [imdChoose] bit DEFAULT (0) NOT NULL,
 [imdErroneous] bit DEFAULT (0) NOT NULL,
 [imdErrDescr] nvarchar(255) NULL,
 [imdBatch] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05rvImportDtls] ADD CONSTRAINT [T05rvImportDtls$PK] PRIMARY KEY ([imdNum])
GO
--CREATE NONCLUSTERED INDEX [T05rvImportDtls$ix_imdBatch] ON [dbo].[T05rvImportDtls] ([imdBatch])
--GO
--CREATE NONCLUSTERED INDEX [T05rvImportDtls$ix_imdDep] ON [dbo].[T05rvImportDtls] ([imdDep])
--GO
--CREATE NONCLUSTERED INDEX [T05rvImportDtls$ix_imdHzNum] ON [dbo].[T05rvImportDtls] ([imdHzNum])
--GO
--CREATE NONCLUSTERED INDEX [T05rvImportDtls$ix_imdImportDate] ON [dbo].[T05rvImportDtls] ([imdImportDate])
--GO
--CREATE NONCLUSTERED INDEX [T05rvImportDtls$ix_imdLak] ON [dbo].[T05rvImportDtls] ([imdLak])
--GO
--CREATE NONCLUSTERED INDEX [T05rvImportDtls$ix_imdMkt] ON [dbo].[T05rvImportDtls] ([imdMkt])
--GO
--CREATE NONCLUSTERED INDEX [T05rvImportDtls$ix_imdNum] ON [dbo].[T05rvImportDtls] ([imdNum])
--GO
--CREATE NONCLUSTERED INDEX [T05rvImportDtls$ix_imdTrgFldrNum] ON [dbo].[T05rvImportDtls] ([imdTrgFldrNum])
--GO

--93: Table T05rvImportIntrFolders
CREATE TABLE [dbo].[T05rvImportIntrFolders]
([intrFolderNum] tinyint NOT NULL,
 [intrFolderPath] nvarchar(255) NULL,
 [intrFolderDesc] nvarchar(124) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05rvImportIntrFolders] ADD CONSTRAINT [T05rvImportIntrFolders$PK] PRIMARY KEY ([intrFolderNum])
GO
--CREATE NONCLUSTERED INDEX [T05rvImportIntrFolders$ix_srcFolderNum] ON [dbo].[T05rvImportIntrFolders] ([intrFolderNum])
--GO

--94: Table T05rvImportSrcFolders
CREATE TABLE [dbo].[T05rvImportSrcFolders]
([srcFolderNum] tinyint NOT NULL,
 [srcFolderPath] nvarchar(255) NULL,
 [srcFolderDesc] nvarchar(124) NULL,
 [srcFolderPriority] tinyint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05rvImportSrcFolders] ADD CONSTRAINT [T05rvImportSrcFolders$PK] PRIMARY KEY ([srcFolderNum])
GO
--CREATE NONCLUSTERED INDEX [T05rvImportSrcFolders$ix_srcFolderNum] ON [dbo].[T05rvImportSrcFolders] ([srcFolderNum])
--GO
--CREATE NONCLUSTERED INDEX [T05rvImportSrcFolders$ix_srcFolderPriority] ON [dbo].[T05rvImportSrcFolders] ([srcFolderPriority])
--GO

--95: Table T05rvImportTrgFolders
CREATE TABLE [dbo].[T05rvImportTrgFolders]
([trgFolderNum] tinyint NOT NULL,
 [trgFolderPath] nvarchar(255) NULL,
 [trgFolderDesc] nvarchar(124) NULL,
 [trgFolderDep] tinyint NULL,
 [trgFolderHour] datetime NULL,
 [trgFolderType] tinyint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05rvImportTrgFolders] ADD CONSTRAINT [T05rvImportTrgFolders$PK] PRIMARY KEY ([trgFolderNum])
GO
--CREATE NONCLUSTERED INDEX [T05rvImportTrgFolders$ix_srcFolderPriority] ON [dbo].[T05rvImportTrgFolders] ([trgFolderType])
--GO
--CREATE NONCLUSTERED INDEX [T05rvImportTrgFolders$ix_trgFolderDep] ON [dbo].[T05rvImportTrgFolders] ([trgFolderDep])
--GO

--96: Table T05rvShliha
CREATE TABLE [dbo].[T05rvShliha]
([ShlihaHaz] int NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05rvShliha] ADD CONSTRAINT [T05rvShliha$PK] PRIMARY KEY ([ShlihaHaz])
GO

--97: Table T05Shlavim
CREATE TABLE [dbo].[T05Shlavim]
([rslcounterShlav] int IDENTITY(1, 1) NOT NULL,
 [rslKodShlav] nvarchar(4) NOT NULL,
 [rslTeurShlav] nvarchar(30) NULL,
 [rslKodOved] int NULL,
 [rslYemeyAvoda] tinyint NULL,
 [rslBechar] bit DEFAULT (0) NOT NULL,
 [rslEfyun] tinyint NULL,
 [rslTekenHours] tinyint NULL,
 [rslTekenMinutes] tinyint NULL,
 [rslCalcQty] bit DEFAULT (0) NOT NULL,
 [rslWaitDays] tinyint NULL,
 [rslWaitHours] tinyint NULL,
 [rslWaitMinutes] tinyint NULL,
 [rslFinishTime] datetime NULL,
 [rslCost] money NULL,
 [rslOnlyTM] bit DEFAULT (0) NOT NULL,
 [rslOrder] int NULL,
 [rslKodMahlaka] nvarchar(4) NULL,
 [rslBaseDate] tinyint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Shlavim] ADD CONSTRAINT [T05Shlavim$PK] PRIMARY KEY ([rslcounterShlav])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T05Shlavim$ix_rslKodShlav] ON [dbo].[T05Shlavim] ([rslKodShlav]) WHERE [rslKodShlav] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T05Shlavim$ix_ifyun] ON [dbo].[T05Shlavim] ([rslEfyun]) WHERE [rslEfyun] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T05Shlavim$ix_rslKodMahlaka] ON [dbo].[T05Shlavim] ([rslKodMahlaka])
--GO
CREATE NONCLUSTERED INDEX [T05Shlavim$ix_rslOrder] ON [dbo].[T05Shlavim] ([rslOrder])
GO

--98: Table T05Shlihim
CREATE TABLE [dbo].[T05Shlihim]
([shhNumShaliah] int NOT NULL,
 [shhFullName] nvarchar(255) NULL,
 [shhTel1] varchar(20) NULL,
 [shhTel2] varchar(20) NULL,
 [shhTel3] varchar(20) NULL,
 [shhComm] varchar(255) NULL,
 [shhPaturMaam] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Shlihim] ADD CONSTRAINT [T05Shlihim$PK] PRIMARY KEY ([shhNumShaliah])
GO

--99: Table T05Shlihut
CREATE TABLE [dbo].[T05Shlihut]
([shlAutoId] int IDENTITY(1, 1) NOT NULL,
 [shlNumShaliah] int NOT NULL,
 [shlDateTime] datetime DEFAULT (GETDATE()) NULL,
 [shlInOut] tinyint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Shlihut] ADD CONSTRAINT [T05Shlihut$PK] PRIMARY KEY ([shlAutoId])
GO
CREATE NONCLUSTERED INDEX [T05Shlihut$ix_shlNumShaliah] ON [dbo].[T05Shlihut] ([shlNumShaliah])
GO

--100: Table T05ShlihutDtls
CREATE TABLE [dbo].[T05ShlihutDtls]
([shldNumShlihut] int NOT NULL,
 [shldNumLakoah] int NOT NULL,
 [shldNumBag] int NULL,
 [shldComm] nvarchar(65) NULL,
 [rv] rowversion NOT NULL
)
GO

--101: Table T05Signes
CREATE TABLE [dbo].[T05Signes]
([sgn_Number] int NOT NULL,
 [sgn_Name] nvarchar(20) NULL,
 [sgn_Picture] nvarchar(2) NULL,
 [sgn_Color] nvarchar(15) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Signes] ADD CONSTRAINT [T05Signes$PK] PRIMARY KEY ([sgn_Number])
GO

--102: Table T05Transmit
CREATE TABLE [dbo].[T05Transmit]
([id] int IDENTITY(1, 1) NOT NULL,
 [sug] tinyint NOT NULL,
 [num] int NOT NULL
)
GO
ALTER TABLE [dbo].[T05Transmit] ADD CONSTRAINT [T05Transmit$PK] PRIMARY KEY ([id])
GO
CREATE NONCLUSTERED INDEX [T05Transmit$ix_dual] ON [dbo].[T05Transmit] ([sug], [num])
GO
CREATE NONCLUSTERED INDEX [T05Transmit$ix_sug] ON [dbo].[T05Transmit] ([sug])
GO

--103: Table T05TzlavSignes
CREATE TABLE [dbo].[T05TzlavSignes]
([sgn_MsHazmana] int NOT NULL,
 [sgn_MsShura] tinyint DEFAULT (0) NOT NULL,
 [sgn_MsShen] tinyint DEFAULT (0) NOT NULL,
 [sgn_MsSign] tinyint DEFAULT (0) NULL
)
GO
ALTER TABLE [dbo].[T05TzlavSignes] ADD CONSTRAINT [T05TzlavSignes$PK] PRIMARY KEY ([sgn_MsHazmana], [sgn_MsShura], [sgn_MsShen])
GO

--104: Table T05UnpaidFollowUp
CREATE TABLE [dbo].[T05UnpaidFollowUp]
([id] int IDENTITY(1, 1) NOT NULL,
 [GR] nvarchar(20) NOT NULL,
 [GRdate] datetime NULL,
 [MsHeshbon] int NOT NULL,
 [PoSource] int NULL,
 [PO] nvarchar(15) NULL,
 [lineCounter] int NOT NULL,
 [lineCounterFormerYear] int NULL,
 [caseClosed] bit DEFAULT (0) NOT NULL,
 [comments] nvarchar(255) NULL,
 [choose] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05UnpaidFollowUp] ADD CONSTRAINT [T05UnpaidFollowUp$PK] PRIMARY KEY ([id])
GO
CREATE NONCLUSTERED INDEX [T05UnpaidFollowUp$ix_GR] ON [dbo].[T05UnpaidFollowUp] ([GR])
GO
CREATE NONCLUSTERED INDEX [T05UnpaidFollowUp$ix_GRdate] ON [dbo].[T05UnpaidFollowUp] ([GRdate])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T05UnpaidFollowUp$ix_lineCounter] ON [dbo].[T05UnpaidFollowUp] ([lineCounter])
GO
CREATE NONCLUSTERED INDEX [T05UnpaidFollowUp$ix_lineCounterFormerYear] ON [dbo].[T05UnpaidFollowUp] ([lineCounterFormerYear])
GO
CREATE NONCLUSTERED INDEX [T05UnpaidFollowUp$ix_MsHeshbon] ON [dbo].[T05UnpaidFollowUp] ([MsHeshbon])
GO

--105: Table T05UnpaidMails
CREATE TABLE [dbo].[T05UnpaidMails]
([id] int IDENTITY(1, 1) NOT NULL,
 [NumForThisLine] int NULL,
 [counterLine] int NULL,
 [dateSent] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [hourSent] datetime DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05UnpaidMails] ADD CONSTRAINT [T05UnpaidMails$PK] PRIMARY KEY ([id])
GO
CREATE NONCLUSTERED INDEX [T05UnpaidMails$ix_counterLine] ON [dbo].[T05UnpaidMails] ([counterLine])
GO
--CREATE NONCLUSTERED INDEX [T05UnpaidMails$ix_dateSent] ON [dbo].[T05UnpaidMails] ([dateSent])
--GO
--CREATE NONCLUSTERED INDEX [T05UnpaidMails$ix_hourSent] ON [dbo].[T05UnpaidMails] ([hourSent])
--GO
CREATE UNIQUE NONCLUSTERED INDEX [T05UnpaidMails$ix_UQdual] ON [dbo].[T05UnpaidMails] ([counterLine], [NumForThisLine]) WHERE [counterLine] IS NOT NULL AND [NumForThisLine] IS NOT NULL
GO

--106: Table T05Works
CREATE TABLE [dbo].[T05Works]
([numRpt] int NOT NULL,
 [dateRpt] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [dateTime] datetime DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) NULL,
 [numHaz] int NOT NULL,
 [dateHaz] datetime NULL,
 [lak] int NULL,
 [nameLak] nvarchar(50) NULL,
 [patient] nvarchar(30) NULL,
 [numRofe] int NULL,
 [nameRofe] nvarchar(100) NULL,
 [muzLe] datetime NULL,
 [kuf] nvarchar(10) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05Works] ADD CONSTRAINT [T05Works$PK] PRIMARY KEY ([numRpt], [numHaz])
GO
--CREATE NONCLUSTERED INDEX [T05Works$ix_dateRpt] ON [dbo].[T05Works] ([dateRpt])
--GO
--CREATE NONCLUSTERED INDEX [T05Works$ix_lak] ON [dbo].[T05Works] ([lak])
--GO
--CREATE NONCLUSTERED INDEX [T05Works$ix_numHaz] ON [dbo].[T05Works] ([numHaz])
--GO
--CREATE NONCLUSTERED INDEX [T05Works$ix_numRofe] ON [dbo].[T05Works] ([numRofe])
--GO
--CREATE NONCLUSTERED INDEX [T05Works$ix_numRpt] ON [dbo].[T05Works] ([numRpt])
--GO

--107: Table T05WorkLines
CREATE TABLE [dbo].[T05WorkLines]
([numRpt] int NOT NULL,
 [numHaz] int NOT NULL,
 [numLine] smallint NOT NULL,
 [mkt] nvarchar(24) NULL,
 [teur] nvarchar(255) NULL,
 [teeth] nvarchar(200) NULL,
 [qty] float NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T05WorkLines] ADD CONSTRAINT [T05WorkLines$PK] PRIMARY KEY ([numRpt],[numHaz],[numLine])
GO
--CREATE NONCLUSTERED INDEX [T05WorkLines$ix_numHaz] ON [dbo].[T05WorkLines] ([numHaz])
--GO
--CREATE NONCLUSTERED INDEX [T05WorkLines$ix_numLine] ON [dbo].[T05WorkLines] ([numLine])
--GO
--CREATE NONCLUSTERED INDEX [T05WorkLines$ix_numRpt] ON [dbo].[T05WorkLines] ([numRpt])
--GO

--108: Table T06Etzim
CREATE TABLE [dbo].[T06Etzim]
([etzAv] nvarchar(24) NOT NULL,
 [etzBen] nvarchar(24) NOT NULL,
 [etzKamut] float DEFAULT (0) NULL,
 [etzSeder] varchar(4) NULL,
 [etzShaar] int DEFAULT (0) NULL,
 [etzKodMatbea] int DEFAULT (0) NULL,
 [etzMehirTekenShah] money DEFAULT (0) NULL,
 [etzMehirTekenMatah] money DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T06Etzim] ADD CONSTRAINT [T06Etzim$PK] PRIMARY KEY ([etzAv], [etzBen])
GO

--109: Table T06Instructions
CREATE TABLE [dbo].[T06Instructions]
([ethAv] nvarchar(24) NOT NULL,
 [ethSeder] int NULL,
 [ethBen] nvarchar(24) NOT NULL,
 [ethKamut] float DEFAULT (0) NULL,
 [ethHearot] nvarchar(100) NULL,
 [ethCounter] int IDENTITY(1, 1) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T06Instructions] ADD CONSTRAINT [T06Instruction$PK] PRIMARY KEY ([ethCounter])
GO

--110: Table T06Mutzarim
CREATE TABLE [dbo].[T06Mutzarim]
([AvMsKatalogi] nvarchar(24) NOT NULL,
 [AvMekadem] float DEFAULT (0) NULL,
 [AvTarich] datetime NULL,
 [AvHeara] nvarchar(100) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T06Mutzarim] ADD CONSTRAINT [T06Mutzarim$PK] PRIMARY KEY ([AvMsKatalogi])
GO

--111: Table T06Shlavim
CREATE TABLE [dbo].[T06Shlavim]
([etsAv] nvarchar(24) NOT NULL,
 [etsShlav] int NOT NULL,
 [etsTeur] nvarchar(40) NULL,
 [etsCounter] int IDENTITY(1, 1) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T06Shlavim] ADD CONSTRAINT [T06Shlavim$PK] PRIMARY KEY ([etsCounter])
GO

--112: Table T07Mahlakot
CREATE TABLE [dbo].[T07Mahlakot]
([mhlKod] nvarchar(4) NOT NULL,
 [mhlShem] nvarchar(50) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T07Mahlakot] ADD CONSTRAINT [T07Mahlakot$PK] PRIMARY KEY ([mhlKod])
GO

--113: Table T09CheckCounter
CREATE TABLE [dbo].[T09CheckCounter]
([strMsHeshbon] int NOT NULL,
 [strSiduri] nvarchar(2) NULL,
 [strCounter] nvarchar(7) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09CheckCounter] ADD CONSTRAINT [T09CheckCounter$PK] PRIMARY KEY ([strMsHeshbon])
GO

--114: Table T09Dirug
CREATE TABLE [dbo].[T09Dirug]
([drName] nvarchar(1) NOT NULL,
 [drFrom] int NULL,
 [drTo] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Dirug] ADD CONSTRAINT [T09Dirug$PK] PRIMARY KEY ([drName])
GO

--115: Table T09ezorim
CREATE TABLE [dbo].[T09ezorim]
([KodEzor] nvarchar(3) NOT NULL,
 [TeurEzor] nvarchar(30) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09ezorim] ADD CONSTRAINT [T09ezorim$PK] PRIMARY KEY ([KodEzor])
GO

--115: Table T09FreeText
CREATE TABLE [dbo].[T09FreeText]
([nsKod] int IDENTITY(1, 1) NOT NULL,
 [nsText] nvarchar(max) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09FreeText] ADD CONSTRAINT [T09FreeText$PK] PRIMARY KEY ([nsKod])
GO

--116: Table T09GoremMafne
CREATE TABLE [dbo].[T09GoremMafne]
([mfnShem] nvarchar(100) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09GoremMafne] ADD CONSTRAINT [T09GoremMafne$PK] PRIMARY KEY ([mfnShem])
GO

--117: Table T09Gvanim
CREATE TABLE [dbo].[T09Gvanim]
([gvKod] int NOT NULL,
 [gvTeur] nvarchar(50) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Gvanim] ADD CONSTRAINT [T09Gvanim$PK] PRIMARY KEY ([gvKod])
GO

--118: Table T09HearotLakoah
CREATE TABLE [dbo].[T09HearotLakoah]
([mdlMsLakoah] int NULL,
 [mdlSugLakoah] nvarchar(2) NULL,
 [mdlDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [mdlTime] datetime DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) NULL,
 [mdlHeara] nvarchar(max) NULL,
 [mdlKamut] float DEFAULT (0) NULL,
 [mdlCounter] int IDENTITY(1, 1) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09HearotLakoah] ADD CONSTRAINT [T09HearotLakoah$PK] PRIMARY KEY ([mdlCounter])
GO
CREATE NONCLUSTERED INDEX [T09HearotLakoas$ix_MsLakoa] ON [dbo].[T09HearotLakoah] ([mdlMsLakoah]) WHERE [mdlMsLakoah] IS NOT NULL
GO

--119: Table T09IfunimKotrot
CREATE TABLE [dbo].[T09IfunimKotrot]
([ifkCounter] int NOT NULL,
 [ifkTeur] nvarchar(100) NULL,
 [ifkMulti] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09IfunimKotrot] ADD CONSTRAINT [T09IfunimKotrot$PK] PRIMARY KEY ([ifkCounter])
GO

--120: Table T09IfunimLakoah
CREATE TABLE [dbo].[T09IfunimLakoah]
([iflMsHeshbon] int NOT NULL,
 [iflIfun] int NOT NULL,
 [iflIshur] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09IfunimLakoah] ADD CONSTRAINT [T09IfunimLakoah$PK] PRIMARY KEY ([iflMsHeshbon], [iflIfun])
GO

--121: Table T09IfunimRamot
CREATE TABLE [dbo].[T09IfunimRamot]
([ifCounter] int IDENTITY(1, 1) NOT NULL,
 [ifNumber] int NULL,
 [ifRama] int NULL,
 [ifFather] int DEFAULT (0) NULL,
 [ifKod] int NULL,
 [ifTeur] nvarchar(100) NULL,
 [ifMulti] bit DEFAULT (0) NOT NULL,
 [ifIshur] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
--ALTER TABLE [dbo].[T09IfunimRamot] ADD CONSTRAINT [T09IfunimRamot$PK] PRIMARY KEY ([ifNumber],[ifRama],[ifFather],[ifKod])
--GO
ALTER TABLE [dbo].[T09IfunimRamot] ADD CONSTRAINT [T09IfunimRamot$PK] PRIMARY KEY ([ifCounter])
GO

--122: Table T09IfunimZmani
CREATE TABLE [dbo].[T09IfunimZmani]
([piNumber] int NOT NULL,
 [pi1] nvarchar(255) NULL,
 [pi2] nvarchar(255) NULL,
 [pi3] nvarchar(255) NULL,
 [pi4] nvarchar(255) NULL,
 [pi5] nvarchar(255) NULL,
 [pi6] nvarchar(255) NULL,
 [pi7] nvarchar(255) NULL,
 [pi8] nvarchar(255) NULL,
 [pi9] nvarchar(255) NULL,
 [pi10] nvarchar(255) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09IfunimZmani] ADD CONSTRAINT [T09IfunimZmani$PK] PRIMARY KEY ([piNumber])
GO

--123: Table T09Iruim
CREATE TABLE [dbo].[T09Iruim]
([irKod] int IDENTITY(1, 1) NOT NULL,
 [irShem] nvarchar(50) NULL,
 [irMsLakoah] int NULL,
 [irSugLakoah] nvarchar(2) NULL,
 [irDate] datetime NULL,
 [irTime] datetime NULL,
 [irUs] nvarchar(50) NULL,
 [irHim] nvarchar(50) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Iruim] ADD CONSTRAINT [T09Iruim$PK] PRIMARY KEY ([irKod])
GO

--124: Table T09IruimList
CREATE TABLE [dbo].[T09IruimList]
([irKod] int NOT NULL,
 [irTeur] nvarchar(250) NULL,
 [irYomanMismahim] bit DEFAULT (0) NOT NULL,
 [irYomanYom] bit DEFAULT (0) NOT NULL,
 [irSagur] bit DEFAULT (0) NOT NULL,
 [irOved] int NULL,
 [irYemeiTizkoret] smallint DEFAULT (0) NULL,
 [irColor] smallint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09IruimList] ADD CONSTRAINT [T09IruimList$PK] PRIMARY KEY ([irKod])
GO

--125: Table T09Isuk
CREATE TABLE [dbo].[T09Isuk]
([isKod] nvarchar(4) NOT NULL,
 [isTeur] nvarchar(200) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Isuk] ADD CONSTRAINT [T09Isuk$PK] PRIMARY KEY ([isKod])
GO

--126: Table T09Kesher
CREATE TABLE [dbo].[T09Kesher]
([ksrCounter] int IDENTITY(1, 1) NOT NULL,
 [ksrLakoah] int NULL,
 [ksrSugLakoah] nvarchar(2) NULL,
 [ksrShem] nvarchar(50) NOT NULL,
 [ksrTafkid] nvarchar(50) NULL,
 [ksrTelfon] varchar(14) NULL,
 [ksrPelefon] varchar(14) NULL,
 [ksrFax] varchar(14) NULL,
 [ksrEmail] varchar(100) NULL,
 [ksrHeara] nvarchar(200) NULL,
 [ksrAddr] nvarchar(200) NULL,
 [ksrNumSort] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Kesher] ADD CONSTRAINT [T09Kesher$PK] PRIMARY KEY ([ksrCounter])
GO
--CREATE NONCLUSTERED INDEX [T09Kesher$ix_kshTafkid] ON [dbo].[T09Kesher] ([ksrTafkid])
--GO
CREATE NONCLUSTERED INDEX [T09Kesher$ix_ksrNumLak] ON [dbo].[T09Kesher] ([ksrLakoah]) WHERE [ksrLakoah] IS NOT NULL
GO
CREATE NONCLUSTERED INDEX [T09Kesher$ix_ksrNumSort] ON [dbo].[T09Kesher] ([ksrNumSort])
GO

--127: Table T09Klali
CREATE TABLE [dbo].[T09Klali]
([klTable] nvarchar(3) NOT NULL,
 [klKod] int NOT NULL,
 [klTeur] nvarchar(250) NULL,
 [klCancel] bit DEFAULT (0) NOT NULL,
 [klNumMdbka] int NULL,
 [klPelefon] varchar(12) NULL,
 [klEmail] varchar(250) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Klali] ADD CONSTRAINT [T09Klali$PK] PRIMARY KEY ([klTable], [klKod])
GO

--128: Table T09Mahsanim
CREATE TABLE [dbo].[T09Mahsanim]
([KodMahsan] nvarchar(3) NOT NULL,
 [ShemMahsan] nvarchar(60) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Mahsanim] ADD CONSTRAINT [T09Mahsanim$PK] PRIMARY KEY ([KodMahsan])
GO

--129: Table T09MakavPotenzuali
CREATE TABLE [dbo].[T09MakavPotenzuali]
([mkvCounter] int IDENTITY(1, 1) NOT NULL,
 [mkvMsHeshbon] int NULL,
 [mkvTarich] datetime NULL,
 [mkvIrua] int NULL,
 [mkvHearot] nvarchar(max) NULL,
 [mkvDateMakav] datetime NULL,
 [mkvShaa] datetime NULL,
 [mkvOved] int NULL,
 [mkvDateDone] datetime NULL,
 [mkvPatuah] bit DEFAULT (0) NOT NULL,
 [mkvPriority] smallint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09MakavPotenzuali] ADD CONSTRAINT [T09MakavPotenzuali$PK] PRIMARY KEY ([mkvCounter])
GO
--CREATE NONCLUSTERED INDEX [T09MakavPotenzuali$ix_mkvPriority] ON [dbo].[T09MakavPotenzuali] ([mkvPriority]) WHERE [mkvPriority] IS NOT NULL
--GO

--130: Table T09Matbeot
CREATE TABLE [dbo].[T09Matbeot]
([CrnKodMatbea] tinyint NOT NULL,
 [CrnNameMatbea] nvarchar(8) NULL,
 [crnKupa] int NULL,
 [crnSymbol] nvarchar(6) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Matbeot] ADD CONSTRAINT [T09Matbeot$PK] PRIMARY KEY ([CrnKodMatbea])
GO

--131: Table T09Melel
CREATE TABLE [dbo].[T09Melel]
([mllKod] tinyint NOT NULL,
 [mllTeur] nvarchar(max) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Melel] ADD CONSTRAINT [T09Melel$PK] PRIMARY KEY ([mllKod])
GO

--132: Table T09MoadonLakohot
CREATE TABLE [dbo].[T09MoadonLakohot]
([ptnNumber] int IDENTITY(1, 1) NOT NULL,
 [ptnShem] nvarchar(50) NULL,
 [ptnKtovet] nvarchar(50) NULL,
 [ptnIr] nvarchar(50) NULL,
 [ptnMikud] varchar(10) NULL,
 [ptnTaDoar] varchar(12) NULL,
 [ptnTelephone1] varchar(16) NULL,
 [ptnTelephone2] varchar(16) NULL,
 [ptnPelephone] varchar(16) NULL,
 [ptnFax] varchar(16) NULL,
 [ptnEmail] varchar(50) NULL,
 [ptnSochen] int NULL,
 [ptnMafne] nvarchar(10) NULL,
 [ptnIfun1] nvarchar(10) NULL,
 [ptnIfun2] nvarchar(10) NULL,
 [ptnIfun3] nvarchar(10) NULL,
 [ptnTarichPtiha] datetime NULL,
 [ptnTarichSiha] datetime NULL,
 [ptnTarichMakav] datetime NULL,
 [ptnTarichSgira] datetime NULL,
 [ptnIshKesher] nvarchar(50) NULL,
 [ptnAnsheiKesher] nvarchar(50) NULL,
 [ptnMenahel] nvarchar(50) NULL,
 [ptnHeara] nvarchar(100) NULL,
 [ptnBirth] datetime NULL,
 [ptnGender] nvarchar(1) NULL,
 [ptnFirstName] nvarchar(50) NULL,
 [ptnSagur] bit DEFAULT (0) NOT NULL,
 [ptnOved] int NULL,
 [ptnColor] smallint NULL,
 [ptnMemo] nvarchar(max) NULL,
 [ptnID] varchar(20) NULL,
 [ptnMamad] int NULL,
 [ptnType] int NULL,
 [ptnDarga] int NULL,
 [ptnDateDarga] datetime NULL,
 [ptnTelWork1] varchar(16) NULL,
 [ptnTelWork2] varchar(16) NULL,
 [ptnWorkCity] int NULL,
 [ptnWorkAddress] nvarchar(50) NULL,
 [ptnWorkName] nvarchar(50) NULL,
 [ptnSivug] nvarchar(10) NULL,
 [ptnEthicCode] int NULL,
 [ptnPayMethod] int NULL,
 [ptnNikudKursim] int NULL,
 [ptnKodUnWork] nvarchar(50) NULL,
 [ptnLisenceNum] int NULL,
 [ptnLisenceDate] datetime NULL,
 [ptnFileNum] int NULL,
 [ptnFirstNameEn] nvarchar(50) NULL,
 [ptnFamilyNameEn] nvarchar(50) NULL,
 [ptnAliyaDate] datetime NULL,
 [ptnBirthCountry] int NULL,
 [ptnMahoz] int NULL,
 [ptnDivur] nvarchar(1) NULL,
 [ptnDateHidush] datetime NULL,
 [ptnIshur] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09MoadonLakohot] ADD CONSTRAINT [T09MoadonLakohot$PK] PRIMARY KEY ([ptnNumber])
GO
--CREATE NONCLUSTERED INDEX [T09MoadonLakohot$ix_ptnEthicCode] ON [dbo].[T09MoadonLakohot] ([ptnEthicCode])
--GO
--CREATE NONCLUSTERED INDEX [T09MoadonLakohot$ix_ptnFileNum] ON [dbo].[T09MoadonLakohot] ([ptnFileNum])
--GO
--CREATE NONCLUSTERED INDEX [T09MoadonLakohot$ix_ptnID] ON [dbo].[T09MoadonLakohot] ([ptnID])
--GO
--CREATE NONCLUSTERED INDEX [T09MoadonLakohot$ix_ptnIshur] ON [dbo].[T09MoadonLakohot] ([ptnIshur])
--GO
--CREATE NONCLUSTERED INDEX [T09MoadonLakohot$ix_ptnLisenceNum] ON [dbo].[T09MoadonLakohot] ([ptnLisenceNum])
--GO

--133: Table T09Nosim
CREATE TABLE [dbo].[T09Nosim]
([nosKod] nvarchar(3) NOT NULL,
 [nosTeur] nvarchar(50) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Nosim] ADD CONSTRAINT [T09Nosim$PK] PRIMARY KEY ([nosKod])
GO

--134: Table T09Ovdim
CREATE TABLE [dbo].[T09Ovdim]
([MsOved] int NOT NULL,
 [ShemOved] nvarchar(20) NULL,
 [Sisma] nvarchar(4) NULL,
 [Hasum] bit DEFAULT (0) NOT NULL,
 [ovdMsHeshbon] int DEFAULT (0) NULL,
 [ovdMsMahlaka] int NULL,
 [ovdUser] nvarchar(20) NULL,
 [ovdTel] varchar(15) NULL,
 [ovdFax] varchar(15) NULL,
 [ovdEmail] varchar(50) NULL,
 [ovdSug] nvarchar(2) NULL,
 [ovdTarif] float DEFAULT (0) NULL,
 [ovdBreak] float DEFAULT (0) NULL,
 [ovdID] varchar(11) NULL,
 [ovdTitle] nvarchar(100) NULL,
 [ovdTechnicianNum] int NULL,
 [ovdCanSign] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Ovdim] ADD CONSTRAINT [T09Ovdim$PK] PRIMARY KEY ([MsOved])
GO
--CREATE NONCLUSTERED INDEX [T09Ovdim$ix_ovdID] ON [dbo].[T09Ovdim] ([ovdID])
--GO
--CREATE NONCLUSTERED INDEX [T09Ovdim$ix_ShemOved] ON [dbo].[T09Ovdim] ([ShemOved])
--GO
--CREATE UNIQUE NONCLUSTERED INDEX [T09Ovdim$ix_tech] ON [dbo].[T09Ovdim] ([ovdTechnicianNum])
--GO

--135: Table T09PopUpMsg
CREATE TABLE [dbo].[T09PopUpMsg]
([ppID] int NOT NULL,
 [ppMsg] nvarchar(255) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09PopUpMsg] ADD CONSTRAINT [T09PopUpMsg$PK] PRIMARY KEY ([ppID])
GO

--136: Table T09Pratim
CREATE TABLE [dbo].[T09Pratim]
([rspKodPrat] int NOT NULL,
 [rspTeurPrat] nvarchar(max) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Pratim] ADD CONSTRAINT [T09Pratim$PK] PRIMARY KEY ([rspKodPrat])
GO

--137: Table T09SargelPritim
CREATE TABLE [dbo].[T09SargelPritim]
([srgNumber] tinyint CHECK(srgNumber BETWEEN 1 AND 6) NOT NULL,
 [srgMsParit] nvarchar(24) NULL,
 [srgTeur] nvarchar(20) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09SargelPritim] ADD CONSTRAINT [T09SargelPritim$PK] PRIMARY KEY ([srgNumber])
GO
CREATE UNIQUE NONCLUSTERED INDEX [T09SargelPritim$ix_srgMsParit] ON [dbo].[T09SargelPritim] ([srgMsParit])
GO

--138: Table T09SentSMS
CREATE TABLE [dbo].[T09SentSMS]
([SmsCounter] int IDENTITY(1, 1) NOT NULL,
 [SmsHesh] int NULL,
 [SmsRecipient] nvarchar(20) NULL,
 [SmsMessage] nvarchar(max) NULL,
 [SmsDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [SmsTime] datetime DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) NULL,
 [SmsNote] nvarchar(max) NULL,
 [SmsInOut] tinyint NULL,
 [SmsCourier] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09SentSMS] ADD CONSTRAINT [T09SentSMS$PK] PRIMARY KEY ([SmsCounter])
GO
--CREATE NONCLUSTERED INDEX [T09SentSMS$ix_smDate] ON [dbo].[T09SentSMS] ([SmsDate])
--GO
--CREATE NONCLUSTERED INDEX [T09SentSMS$ix_smHour] ON [dbo].[T09SentSMS] ([SmsTime])
--GO
CREATE NONCLUSTERED INDEX [T09SentSMS$ix_smNumHesh] ON [dbo].[T09SentSMS] ([SmsHesh]) WHERE [SmsHesh] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T09SentSMS$ix_Sms] ON [dbo].[T09SentSMS] ([SmsCourier])
--GO
--CREATE NONCLUSTERED INDEX [T09SentSMS$ix_SmsInOut] ON [dbo].[T09SentSMS] ([SmsInOut])
--GO

--139: Table T09Sgira
CREATE TABLE [dbo].[T09Sgira]
([sgCounter] int IDENTITY(1, 1) NOT NULL,
 [sgAsm] int NULL,
 [sgSug] nvarchar(3) NULL,
 [sgTaarich] datetime NULL,
 [sgShemSoger] nvarchar(200) NULL,
 [sgSiba] int NULL,
 [sgHearot] nvarchar(max) NULL,
 [sgSgPt] nvarchar(5) NULL,
 [sgSugBitul] nvarchar(1) NULL,
 [sgSchum] money DEFAULT (0) NULL,
 [sgShulam] bit DEFAULT (0) NOT NULL,
 [sgSugTashlum] tinyint NULL,
 [sgAsmTashlum] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Sgira] ADD CONSTRAINT [T09Sgira$PK] PRIMARY KEY ([sgCounter])
GO
CREATE NONCLUSTERED INDEX [T09Sgira$ix_sugAsm] ON [dbo].[T09Sgira] ([sgSug], [sgAsm]) WHERE [sgSug] IS NOT NULL AND [sgAsm] IS NOT NULL
GO

--140: Table T09Shearim
CREATE TABLE [dbo].[T09Shearim]
([shrKodMatbea] tinyint NOT NULL,
 [shrDate] datetime NOT NULL,
 [shrShar] money NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Shearim] ADD CONSTRAINT [T09Shearim$PK] PRIMARY KEY ([shrKodMatbea], [shrDate])
GO

--141: Table T09Sochnim
CREATE TABLE [dbo].[T09Sochnim]
([MsSochen] int NOT NULL,
 [ShemSochen] nvarchar(30) NOT NULL,
 [socAhuzAmla] Decimal(6,2) NULL,
 [socKodEzor] nvarchar(3) NULL,
 [socKizuzHanahot] bit DEFAULT (0) NOT NULL,
 [socAhuzMeravi] Decimal(6,4) NULL,
 [socAhuzKizuz] Decimal(6,3) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Sochnim] ADD CONSTRAINT [T09Sochnim$PK] PRIMARY KEY ([MsSochen])
GO

--142: Table T09Yazranim
CREATE TABLE [dbo].[T09Yazranim]
([yzKodYazran] int NOT NULL,
 [yzTeurYazran] nvarchar(30) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T09Yazranim] ADD CONSTRAINT [T09Yazranim$PK] PRIMARY KEY ([yzKodYazran])
GO

--143: Table T10HosimHaadafot
CREATE TABLE [dbo].[T10HosimHaadafot]
([hdnKodNose] nvarchar(6) NOT NULL,
 [hdnTeurNose] nvarchar(50) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T10HosimHaadafot] ADD CONSTRAINT [T10HosimHaadafot$PK] PRIMARY KEY ([hdnKodNose])
GO

--144: Table T10Haadafot
CREATE TABLE [dbo].[T10Haadafot]
([hdCounter] int IDENTITY(1, 1) NOT NULL,
 [hdKodNose] nvarchar(6) NOT NULL,
 [hdSugReshuma] nvarchar(6) NOT NULL,
 [hdKodTshuva] varchar(1) NULL,
 [hdSheela] nvarchar(600) NULL,
 [hdYesNo] bit DEFAULT (0) NOT NULL,
 [hdNumber] smallint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T10Haadafot] ADD CONSTRAINT [T10Haadafot$PK] PRIMARY KEY ([hdCounter])
GO
CREATE NONCLUSTERED INDEX [T10Haadafot$ix_Nose] ON [dbo].[T10Haadafot] ([hdKodNose])
GO
CREATE NONCLUSTERED INDEX [T10Haadafot$ix_SugReshuma] ON [dbo].[T10Haadafot] ([hdSugReshuma])
GO

--145: Table T11Bithonot
CREATE TABLE [dbo].[T11Bithonot]
([btCounter] int IDENTITY(1, 1) NOT NULL,
 [btSnif] nvarchar(3) NULL,
 [btBank] int NULL,
 [btTeur] nvarchar(100) NULL,
 [btSchum] float DEFAULT (0) NULL,
 [btAhuz] float DEFAULT (100) NULL,
 [btDate] datetime NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T11Bithonot] ADD CONSTRAINT [T11Bithonot$PK] PRIMARY KEY ([btCounter])
GO

--146: Table T11CalendarDay
CREATE TABLE [dbo].[T11CalendarDay]
([ymNumber] int NOT NULL,
 [ymDate] datetime NOT NULL,
 [ymAsm] int NULL,
 [ymSubject] nvarchar(200) NULL,
 [ymYtra] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T11CalendarDay] ADD CONSTRAINT [T11CalendarDay$PK] PRIMARY KEY ([ymNumber],[ymDate])
GO

--147: Table T11HoraotKvuot
CREATE TABLE [dbo].[T11HoraotKvuot]
([kavKod] int IDENTITY(1, 1) NOT NULL,
 [kavPratim] nvarchar(max) NULL,
 [kavDay] int CHECK(kavDay < 32) NULL,
 [kavSum] float DEFAULT (0) NULL,
 [kavFrequency] int NULL,
 [kavIshur] bit DEFAULT (0) NOT NULL,
 [kavLastFrom] datetime NULL,
 [kavLastTo] datetime NULL,
 [kavKodHZ] nvarchar(2) NULL,
 [kavBank] int NULL,
 [kavNose] int NULL,
 [kavSnif] nvarchar(3) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T11HoraotKvuot] ADD CONSTRAINT [T11HoraotKvuot$PK] PRIMARY KEY ([kavKod])
GO

--148: Table T11HzmNosim
CREATE TABLE [dbo].[T11HzmNosim]
([nosKod] int IDENTITY(1, 1) NOT NULL,
 [nosSnif] int NULL,
 [nosTeur] nvarchar(200) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T11HzmNosim] ADD CONSTRAINT [T11HzmNosim$PK] PRIMARY KEY ([nosKod])
GO

--149: Table T11HzmShurot
CREATE TABLE [dbo].[T11HzmShurot]
([ttmSnif] int NULL,
 [ttmKodNose] int NULL,
 [ttmCounter] int IDENTITY(1, 1) NOT NULL,
 [ttmMsHeshbon] int NULL,
 [ttmAsm] int NULL,
 [ttmDate] datetime NULL,
 [ttmErech] datetime NULL,
 [ttmMatah] Decimal(18,2) DEFAULT (0) NULL,
 [ttmKodMatah] tinyint NULL,
 [ttmIshur] bit DEFAULT (0) NOT NULL,
 [ttmSagur] bit DEFAULT (0) NOT NULL,
 [ttmKodHZ] nvarchar(1) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T11HzmShurot] ADD CONSTRAINT [T11HzmShurot$PK] PRIMARY KEY ([ttmCounter])
GO

--150: Table T11Nosim
CREATE TABLE [dbo].[T11Nosim]
([thnKod] int IDENTITY(1, 1) NOT NULL,
 [thnTeur] nvarchar(200) NULL,
 [thnTakbul] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T11Nosim] ADD CONSTRAINT [T11Nosim$PK] PRIMARY KEY ([thnKod])
GO

--151: Table T11NosimShurot
CREATE TABLE [dbo].[T11NosimShurot]
([thCounter] int IDENTITY(1, 1) NOT NULL,
 [thNose] int NULL,
 [thPratim] nvarchar(100) NULL,
 [thSum] money DEFAULT (0) NULL,
 [thDate] datetime NULL,
 [tnIshur] bit DEFAULT (0) NOT NULL,
 [thSagur] bit DEFAULT (0) NOT NULL,
 [thRishum] datetime NULL,
 [thBealim] int NULL,
 [thMatbea] tinyint NULL,
 [thAhuz] float DEFAULT (0) NULL,
 [thNosim] int NULL,
 [thBank] int DEFAULT (0) NULL,
 [thAsm] varchar(10) NULL,
 [thStatus] int NULL,
 [thMatah] float DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T11NosimShurot] ADD CONSTRAINT [T11NosimShurot$PK] PRIMARY KEY ([thCounter])
GO

--152: Table T11Sivugim
CREATE TABLE [dbo].[T11Sivugim]
([stKod] int NOT NULL,
 [stTeur] nvarchar(50) NULL,
 [stAhuz] float NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T11Sivugim] ADD CONSTRAINT [T11Sivugim$PK] PRIMARY KEY ([stKod])
GO

--153: Table T11Tnuot
CREATE TABLE [dbo].[T11Tnuot]
([TnzCounter] int IDENTITY(1, 1) NOT NULL,
 [TnzMsHeshbon] int NULL,
 [TnzMsNegdi] int NULL,
 [TnzSugPkuda] int NULL,
 [TnzPkuda] int NULL,
 [TnzShura] smallint NULL,
 [TnzSugTnua] nvarchar(3) NULL,
 [TnzHaklada] datetime NULL,
 [TnzTarich] datetime NULL,
 [TnzErech] datetime NULL,
 [TnzSchum] money DEFAULT (0) NULL,
 [TnzKodHZ] nvarchar(1) NULL,
 [TnzAsm1] int NULL,
 [TnzAsm2] int NULL,
 [TnzAsm3] int NULL,
 [TnzHukbal] money DEFAULT (0) NULL,
 [TnzPatuah] bit DEFAULT (0) NOT NULL,
 [TnzMatah] float DEFAULT (0) NULL,
 [TnzMatbea] varchar(1) NULL,
 [TnzKamut] money DEFAULT (0) NULL,
 [TnzMatbea2] varchar(1) NULL,
 [TnzPratim] nvarchar(130) NULL,
 [TnzSugMimsar] varchar(2) NULL,
 [TnzMisparMimsar] nvarchar(10) NULL,
 [TnzHevratAshray] nvarchar(50) NULL,
 [TnzBank] varchar(2) NULL,
 [TnzSnif] varchar(3) NULL,
 [TnzHesBank] varchar(16) NULL,
 [TnzMakor] varchar(4) NULL,
 [TnzSchumBefoal] money DEFAULT (0) NULL,
 [TnzOdef] money DEFAULT (0) NULL,
 [TnzNikuy] money DEFAULT (0) NULL,
 [TnzRelIska] bit DEFAULT (0) NOT NULL,
 [TnzfBealim] int NULL,
 [tnzOved] int NULL,
 [TnzIshur] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T11Tnuot] ADD CONSTRAINT [T11Tnuot$PK] PRIMARY KEY ([TnzCounter])
GO

--154: Table T13Hiuvim
CREATE TABLE [dbo].[T13Hiuvim]
([hvkodMusad] int NOT NULL,
 [hvKodClass] varchar(4) NOT NULL,
 [hvSum] money DEFAULT (0) NULL,
 [hvNose] int NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T13Hiuvim] ADD CONSTRAINT [T13Hiuvim$PK] PRIMARY KEY ([hvkodMusad],[hvKodClass],[hvNose])
GO

--155: Table T13HiuvOnce
CREATE TABLE [dbo].[T13HiuvOnce]
([zmnCounter] int IDENTITY(1, 1) NOT NULL,
 [zmnMsHeshbon] int NULL,
 [zmnSum] money DEFAULT (0) NULL,
 [zmnNotes] nvarchar(100) NULL,
 [zmnIshur] bit DEFAULT (0) NOT NULL,
 [zmnSagurNum] int NULL,
 [zmnNose] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T13HiuvOnce] ADD CONSTRAINT [T13HiuvOnce$PK] PRIMARY KEY ([zmnCounter])
GO

--156: Table T13HoraotKoteret
CREATE TABLE [dbo].[T13HoraotKoteret]
([htAsm] int NOT NULL,
 [htDate] datetime NULL,
 [htMsHeshbon] int NULL,
 [htShemHeshbon] nvarchar(50) NULL,
 [htSum] money DEFAULT (0) NULL,
 [htTeur] nvarchar(100) NULL,
 [htAhuzNikui] float DEFAULT (0) NULL,
 [htSumNikui] money DEFAULT (0) NULL,
 [htSumTot] money DEFAULT (0) NULL,
 [htYadani] nvarchar(1) NULL,
 [htHadpasa] bit DEFAULT (0) NOT NULL,
 [htBank] int DEFAULT (0) NULL,
 [htIshur] bit DEFAULT (0) NOT NULL,
 [htStatus] int NULL,
 [htSignA] nvarchar(35) NULL,
 [htSignB] nvarchar(35) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T13HoraotKoteret] ADD CONSTRAINT [T13HoraotKoteret$PK] PRIMARY KEY ([htAsm])
GO
CREATE NONCLUSTERED INDEX [T13HoraotKoteret$ix_htMsHeshbon] ON [dbo].[T13HoraotKoteret] ([htMsHeshbon]) WHERE [htMsHeshbon] IS NOT NULL
GO
--CREATE NONCLUSTERED INDEX [T13HoraotKoteret$ix_htSignA] ON [dbo].[T13HoraotKoteret] ([htSignA])
--GO
--CREATE NONCLUSTERED INDEX [T13HoraotKoteret$ix_htSignB] ON [dbo].[T13HoraotKoteret] ([htSignB])
--GO

--157: Table T13HoraotShurot
CREATE TABLE [dbo].[T13HoraotShurot]
([htsCounter] int IDENTITY(1, 1) NOT NULL,
 [htsAsm] int NULL,
 [htsTeur] nvarchar(100) NULL,
 [htsSchum] money DEFAULT (0) NULL,
 [htsAsmMakor] int NULL,
 [htsSugMakor] nvarchar(3) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T13HoraotShurot] ADD CONSTRAINT [T13HoraotShurot$PK] PRIMARY KEY ([htsCounter])
GO

--158: Table T13HoraotFinanci
CREATE TABLE [dbo].[T13HoraotFinanci]
([htfCounter] int IDENTITY(1, 1) NOT NULL,
 [htfAsm] int NULL,
 [htfDate] datetime NULL,
 [htfSum] money DEFAULT (0) NULL,
 [htfMsReshima] int NULL,
 [htfHubad] bit DEFAULT (0) NOT NULL,
 [htfIshur] bit DEFAULT (0) NOT NULL,
 [htfAsmSoger] int NULL,
 [htfAsmSoger2] int NULL,
 [htfSugSoger] nvarchar(3) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T13HoraotFinanci] ADD CONSTRAINT [T13HoraotFinanci$PK] PRIMARY KEY ([htfCounter])
GO

--159: Table T13msvLakohot
CREATE TABLE [dbo].[T13msvLakohot]
([msvMsHeshbon] int NULL,
 [msvMeDate] datetime NULL,
 [msvToDate] datetime NULL,
 [msvYom] tinyint DEFAULT (0) NULL,
 [msvFirstSum] money DEFAULT (0) NULL,
 [msvNextSum] money DEFAULT (0) NULL,
 [msvNose] int NULL,
 [msvSagur] bit DEFAULT (0) NOT NULL,
 [msvDateBitul] datetime NULL,
 [msvHearot] nvarchar(50) NULL,
 [msvCounter] int IDENTITY(1, 1) NOT NULL,
 [msvIshur] bit DEFAULT (0) NOT NULL,
 [msvStudent] nvarchar(200) NULL,
 [msvMusad] int NULL,
 [msvClass] nvarchar(4) NULL,
 [msvFMonth] varchar(2) NULL,
 [msvFYear] varchar(4) NULL,
 [msvNumMonth] smallint DEFAULT (0) NULL,
 [msvTotal] money DEFAULT (0) NULL,
 [msvNumStud] int NULL,
 [msvSugPayment] tinyint NULL,
 [msvSugCasualPayment] tinyint NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T13msvLakohot] ADD CONSTRAINT [T13msvLakohot$PK] PRIMARY KEY ([msvCounter])
GO

--160: Table T13msvReshima
CREATE TABLE [dbo].[T13msvReshima]
([mskCounter] int IDENTITY(1, 1) NOT NULL,
 [mskPay] bit DEFAULT (0) NOT NULL,
 [mskDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [mskDateSent] datetime NULL,
 [mskOnce] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T13msvReshima] ADD CONSTRAINT [T13msvReshima$PK] PRIMARY KEY ([mskCounter])
GO

--161: Table T13ShvaGvia
CREATE TABLE [dbo].[T13ShvaGvia]
([msgCounter] int NULL,
 [msgDate] datetime DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) NULL,
 [msgMsHeshbon] int NULL,
 [msgSum] money DEFAULT (0) NULL,
 [msgHubad] bit DEFAULT (0) NOT NULL,
 [msgAsmSoger] int NULL,
 [msgSugSoger] nvarchar(3) NULL,
 [msgSiduri] int NULL,
 [msgStudents] bit DEFAULT (0) NOT NULL,
 [msgFDate] datetime NULL,
 [msgTDate] datetime NULL,
 [rv] rowversion NOT NULL
)
GO
--CREATE NONCLUSTERED INDEX [T13ShvaGvia$ix_msgSiduri] ON [dbo].[T13ShvaGvia] ([msgSiduri])
--GO

--162: Table T13shvLakohot
CREATE TABLE [dbo].[T13shvLakohot]
([msvMsHeshbon] int NULL,
 [msvMeDate] datetime NULL,
 [msvToDate] datetime NULL,
 [msvYom] real DEFAULT (0) NULL,
 [msvFirstSum] money DEFAULT (0) NULL,
 [msvNextSum] money DEFAULT (0) NULL,
 [msvNose] int NULL,
 [msvSagur] bit DEFAULT (0) NOT NULL,
 [msvDateBitul] datetime NULL,
 [msvHearot] nvarchar(50) NULL,
 [msvCounter] int IDENTITY(1, 1) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
--CREATE NONCLUSTERED INDEX [T13shvLakohot$ix_msvMsHeshbon] ON [dbo].[T13shvLakohot] ([msvMsHeshbon])
--GO
--ALTER TABLE [dbo].[T13shvLakohot] ADD CONSTRAINT [T13shvLakohot$PK] PRIMARY KEY ([msvCounter])
--GO

--163: Table T13Students
CREATE TABLE [dbo].[T13Students]
([mslCounter] int NULL,
 [mslStudent] nvarchar(200) NULL,
 [mslMusad] int NULL,
 [mslClass] nvarchar(4) NULL,
 [mslNose] int NULL,
 [mslTotal] money DEFAULT (0) NULL,
 [mslDateBirth] datetime NULL,
 [mslDateAlia] datetime NULL,
 [mslDateKnisa] datetime NULL,
 [mslCountry] nvarchar(50) NULL,
 [mslPaymentTrms] nvarchar(10) NULL,
 [mslID] varchar(10) NULL,
 [mslSex] nvarchar(1) NULL,
 [mslName] nvarchar(30) NULL,
 [mslFamily] nvarchar(50) NULL,
 [mslAhuz] float DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO
--CREATE NONCLUSTERED INDEX [T13Students$ix_mslID] ON [dbo].[T13Students] ([mslID])
--GO

--164: Table T14DapeiBankK
CREATE TABLE [dbo].[T14DapeiBankK]
([bnkBank] int NOT NULL,
 [bnkDaf] int NOT NULL,
 [bnkPtiha] money DEFAULT (0) NULL,
 [bnkHZ] nvarchar(1) NULL,
 [bnkDaysYear] smallint DEFAULT (365) NULL,
 [bnkMatah] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T14DapeiBankK] ADD CONSTRAINT [T14DapeiBankK$PK] PRIMARY KEY ([bnkBank], [bnkDaf])
GO

--165: Table T14DapeiBankS
CREATE TABLE [dbo].[T14DapeiBankS]
([bnsCounter] int DEFAULT (0) NULL,
 [bnsBank] int NULL,
 [bnsDaf] int NULL,
 [bnsDate] datetime NULL,
 [bnsAsm] int NULL,
 [bnsPratim] nvarchar(50) NULL,
 [bnsSchum] money DEFAULT (0) NULL,
 [bnsHZ] nvarchar(1) NULL,
 [bnsErech] datetime NULL,
 [bnsSagur] int NULL,
 [bnsIshur] bit DEFAULT (0) NOT NULL,
 [bnsPeula] nvarchar(3) NULL,
 [bnsRibit] bit DEFAULT (0) NOT NULL,
 [bnsKey] int IDENTITY(1, 1) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T14DapeiBankS] ADD CONSTRAINT [T14DapeiBankS$PK] PRIMARY KEY ([bnsKey])
GO

--166: Table T14RbBank
CREATE TABLE [dbo].[T14RbBank]
([rbbBank] int NULL,
 [rbbDate] datetime NULL,
 [rbbSum] float DEFAULT (0) NULL,
 [rv] rowversion NOT NULL
)
GO

--167: Table T14RbMethod
CREATE TABLE [dbo].[T14RbMethod]
([rsFromDate] datetime NULL,
 [rsToDate] datetime NULL,
 [rsMethod] nvarchar(6) DEFAULT ('רבעון') NULL
)
GO

--168: Table T15Sivugim
CREATE TABLE [dbo].[T15Sivugim]
([svgKod] nvarchar(2) NOT NULL,
 [svgTeur] nvarchar(160) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T15Sivugim] ADD CONSTRAINT [T15Sivugim$PK] PRIMARY KEY ([svgKod])
GO

--169: Table T15Tnuot
CREATE TABLE [dbo].[T15Tnuot]
([TnzCounter] int IDENTITY(1, 1) NOT NULL,
 [TnzMsHeshbon] int NULL,
 [TnzMsNegdi] int NULL,
 [TnzSugPkuda] tinyint DEFAULT (0) NULL,
 [TnzPkuda] int DEFAULT (0) NULL,
 [TnzShura] smallint NULL,
 [TnzSugTnua] nvarchar(3) NULL,
 [TnzHaklada] datetime NULL,
 [TnzTarich] datetime NULL,
 [TnzErech] datetime NULL,
 [TnzSchum] money DEFAULT (0) NULL,
 [TnzMaam] money DEFAULT (0) NULL,
 [TnzSumTotal] money DEFAULT (0) NULL,
 [TnzKodHZ] varchar(1) NULL,
 [TnzAsm1] int NULL,
 [TnzAsm2] int NULL,
 [TnzAsm3] int NULL,
 [TnzHukbal] money DEFAULT (0) NULL,
 [TnzPatuah] bit DEFAULT (0) NOT NULL,
 [TnzMatah] money DEFAULT (0) NULL,
 [TnzMatbea] varchar(1) NULL,
 [TnzKamut] money DEFAULT (0) NULL,
 [TnzMatbea2] varchar(1) NULL,
 [TnzPratim] nvarchar(50) NULL,
 [TnzSugMimsar] varchar(2) NULL,
 [TnzMisparMimsar] varchar(10) NULL,
 [TnzHevratAshray] varchar(50) NULL,
 [TnzBank] int NULL,
 [TnzSnif] varchar(3) NULL,
 [TnzHesBank] varchar(16) NULL,
 [TnzMakor] varchar(4) NULL,
 [TnzSchumBefoal] money DEFAULT (0) NULL,
 [TnzOdef] money DEFAULT (0) NULL,
 [TnzNikuy] money DEFAULT (0) NULL,
 [TnzRelIska] bit DEFAULT (0) NOT NULL,
 [TnzfBealim] int NULL,
 [tnzOved] int NULL,
 [TnzIshur] bit DEFAULT (0) NOT NULL,
 [tnzSivug] nvarchar(2) NULL,
 [tnzYearMAs] int NULL,
 [tnzMsHevra] int NULL,
 [tnzMonthWork] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T15Tnuot] ADD CONSTRAINT [T15Tnuot$PK] PRIMARY KEY ([TnzCounter])
GO

--170: Table T30Peulot
CREATE TABLE [dbo].[T30Peulot]
([IdPeula] int NOT NULL,
 [TeurPeula] nvarchar(140) NULL,
 [SismatPeula] nvarchar(33) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T30Peulot] ADD CONSTRAINT [T30Peulot$PK] PRIMARY KEY ([IdPeula])
GO

--171: Table T30Harshaot
CREATE TABLE [dbo].[T30Harshaot]
([idHarshaa] int NULL,
 [idPeula] int NOT NULL,
 [idOved] int NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[T30Harshaot] ADD CONSTRAINT [T30Harshaot$PK] PRIMARY KEY ([idPeula], [idOved])
GO

--172: Table TablesForCopy
CREATE TABLE [dbo].[TablesForCopy]
([cpTableName] nvarchar(100) NOT NULL,
 [cpApplication] bit DEFAULT (0) NOT NULL
)
GO
ALTER TABLE [dbo].[TablesForCopy] ADD CONSTRAINT [TablesForCopy$PK] PRIMARY KEY ([cpTableName])
GO

--173: Table tbl_Params
CREATE TABLE [dbo].[tbl_Params]
([prm1YN] bit DEFAULT (0) NOT NULL,
 [prm1Str] nvarchar(100) NULL,
 [prm2YN] bit DEFAULT (0) NOT NULL,
 [prm2Str] nvarchar(100) NULL,
 [prm3YN] bit DEFAULT (0) NOT NULL,
 [prm3Str] nvarchar(100) NULL,
 [prm4YN] bit DEFAULT (0) NOT NULL,
 [prm4From] int NULL,
 [prm4To] int NULL,
 [prm5YN] bit DEFAULT (0) NOT NULL,
 [prm5From] int NULL,
 [prm5To] int NULL,
 [prm6From] datetime DEFAULT (GETDATE()) NULL,
 [prm6To] datetime NULL,
 [prm7YN] varchar(1) NULL,
 [prm7From] int NULL,
 [prm7To] int NULL,
 [prmYtra] float DEFAULT (0) NULL
)
GO

--174: Table TezrHash
CREATE TABLE [dbo].[TezrHash]
([tnCounter] int NOT NULL
)
GO
ALTER TABLE [dbo].[TezrHash] ADD CONSTRAINT [TezrHash$PK] PRIMARY KEY ([tnCounter])
GO

--175: Table TezrKishurHafk
CREATE TABLE [dbo].[TezrKishurHafk]
([hfkHafkada] int NOT NULL,
 [hfkKabala] int NOT NULL,
 [hfkBank] int NULL,
 [hfkMsHeshbon] int NULL,
 [hfkSugTnua] nvarchar(3) NULL
)
GO
ALTER TABLE [dbo].[TezrKishurHafk] ADD CONSTRAINT [TezrKishurHafk$PK] PRIMARY KEY ([hfkHafkada], [hfkKabala])
GO

--176: Table TezrPath
CREATE TABLE [dbo].[TezrPath]
([kodPath] nvarchar(16) NOT NULL,
 [path] nvarchar(300) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[TezrPath] ADD CONSTRAINT [TezrPath$PK] PRIMARY KEY ([kodPath])
GO

--177: Table TezrShoviMly
CREATE TABLE [dbo].[TezrShoviMly]
([shoviDate] datetime NOT NULL,
 [shoviMahsan] smallint NOT NULL,
 [shoviSum] money DEFAULT (0) NULL,
 [shoviSug] nvarchar(1) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[TezrShoviMly] ADD CONSTRAINT [TezrShoviMly$PK] PRIMARY KEY ([shoviDate],[shoviMahsan])
GO

--178: Table TIndHashav
CREATE TABLE [dbo].[TIndHashav]
([hashOur] int NULL,
 [hashThem] nvarchar(10) NULL,
 [rv] rowversion NOT NULL
)
GO
CREATE NONCLUSTERED INDEX [TIndHashav$ix_our_n] ON [dbo].[TIndHashav] ([hashOur])
GO
CREATE NONCLUSTERED INDEX [TIndHashav$ix_them_n] ON [dbo].[TIndHashav] ([hashThem])
GO

--179: Table TMatHashav
CREATE TABLE [dbo].[TMatHashav]
([hashOur] tinyint NULL,
 [hashThem] nvarchar(2) NULL
)
GO

--180: Table TMeholel
CREATE TABLE [dbo].[TMeholel]
([mhCounter] int IDENTITY(1, 1) NOT NULL,
 [mhTxtTitle] nvarchar(250) NULL,
 [mhCboTable] nvarchar(100) NULL,
 [mhListFields] nvarchar(max) NULL,
 [mhListSums] nvarchar(max) NULL,
 [mhListSort] nvarchar(100) NULL,
 [mhListSort1] nvarchar(100) NULL,
 [mhNewSec] bit DEFAULT (0) NOT NULL,
 [mhPortLand] tinyint DEFAULT (1) NULL,
 [mhKoteret1] bit DEFAULT (0) NOT NULL,
 [mhLineCount1] bit DEFAULT (0) NOT NULL,
 [mhLineCount] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[TMeholel] ADD CONSTRAINT [TMeholel$PK] PRIMARY KEY ([mhCounter])
GO

--181: Table TMeholel2
CREATE TABLE [dbo].[TMeholel2]
([mmCounter] int NOT NULL,
 [mmNumMiun] tinyint NOT NULL,
 [mhListSort] nvarchar(100) NULL,
 [mhNewSec] bit DEFAULT (0) NOT NULL,
 [mhKoteret1] bit DEFAULT (0) NOT NULL,
 [mhLineCount1] bit DEFAULT (0) NOT NULL,
 [mhSubSum1] bit DEFAULT (0) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[TMeholel2] ADD CONSTRAINT [TMeholel2$PK] PRIMARY KEY ([mmCounter], [mmNumMiun])
GO

--183: Table TMeholel3
CREATE TABLE [dbo].[TMeholel3]
([mkCounter] int NOT NULL,
 [mkOldName] nvarchar(100) NULL,
 [mkNewName] nvarchar(100) NULL,
 [mhId] int IDENTITY(1, 1) NOT NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[TMeholel3] ADD CONSTRAINT [TMeholel3$PK] PRIMARY KEY ([mhId])
GO
CREATE NONCLUSTERED INDEX [TMeholel3$ix_Counter] ON [dbo].[TMeholel3] ([mkCounter])
GO

--184: Table TShilaCollectedFiles
CREATE TABLE [dbo].[TShilaCollectedFiles]
([id] int IDENTITY(1, 1) NOT NULL,
 [FileName] nvarchar(160) NULL,
 [DateCollected] datetime DEFAULT (GETDATE()) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[TShilaCollectedFiles] ADD CONSTRAINT [TShilaCollectedFiles$PK] PRIMARY KEY ([id])
GO
--CREATE NONCLUSTERED INDEX [TShilaCollectedFiles$ix_Dt] ON [dbo].[TShilaCollectedFiles] ([DateCollected])
--GO
CREATE NONCLUSTERED INDEX [TShilaCollectedFiles$ix_FileName] ON [dbo].[TShilaCollectedFiles] ([FileName]) WHERE [FileName] IS NOT NULL
GO

--185: Table TShilaConvMkt
CREATE TABLE [dbo].[TShilaConvMkt]
([id] int IDENTITY(1, 1) NOT NULL,
 [sourceId] int NOT NULL,
 [ShilaMakat] nvarchar(24) NOT NULL,
 [ShilaTeurParit] nvarchar(255) NULL,
 [OurMakat] nvarchar(24) NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[TShilaConvMkt] ADD CONSTRAINT [TShilaConvMkt$PK] PRIMARY KEY ([id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [TShilaConvMkt$ix_DualIx] ON [dbo].[TShilaConvMkt] ([sourceId], [ShilaMakat])
GO
CREATE UNIQUE NONCLUSTERED INDEX [TShilaConvMkt$ix_tripleIx] ON [dbo].[TShilaConvMkt] ([sourceId], [ShilaMakat], [OurMakat])
GO

--186: Table TShilaConvRof
CREATE TABLE [dbo].[TShilaConvRof]
([id] int IDENTITY(1, 1) NOT NULL,
 [sourceId] int NOT NULL,
 [ShilaNameRofe] nvarchar(255) NOT NULL,
 [OurNumRofe] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[TShilaConvRof] ADD CONSTRAINT [TShilaConvRof$PK] PRIMARY KEY ([id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [TShilaConvRof$ix_DualIx] ON [dbo].[TShilaConvRof] ([sourceId], [ShilaNameRofe])
GO
CREATE UNIQUE NONCLUSTERED INDEX [TShilaConvRof$ix_tripleIx] ON [dbo].[TShilaConvRof] ([sourceId], [ShilaNameRofe], [OurNumRofe])
GO

--187: Table TShilaConvSnifLak
CREATE TABLE [dbo].[TShilaConvSnifLak]
([id] int IDENTITY(1, 1) NOT NULL,
 [sourceId] int NOT NULL,
 [ShilaKodSnif] int NOT NULL,
 [ShilaTeurSnif] nvarchar(255) NULL,
 [OurNumLakoah] int NULL,
 [rv] rowversion NOT NULL
)
GO
ALTER TABLE [dbo].[TShilaConvSnifLak] ADD CONSTRAINT [TShilaConvSnifLak$PK] PRIMARY KEY ([id])
GO
CREATE UNIQUE NONCLUSTERED INDEX [TShilaConvSnifLak$ix_DualIx] ON [dbo].[TShilaConvSnifLak] ([sourceId], [ShilaKodSnif])
GO
CREATE UNIQUE NONCLUSTERED INDEX [TShilaConvSnifLak$ix_tripleIx] ON [dbo].[TShilaConvSnifLak] ([sourceId], [ShilaKodSnif], [OurNumLakoah])
GO

--188: Table Used3RandomChars
CREATE TABLE [dbo].[Used3RandomChars]
([Used3Chars] nvarchar(3) NULL
)
GO

/*
Run in Access data bnXXXX.mdb:
DELETE * FROM T02YtrotMly WHERE (((T02YtrotMly.[ymlMahsan]) Is Null));
DELETE * FROM T05Mahlakot;

=======================================================================
N O W   R U N   S S M A  to migrate all the above tables to SQL Server.
=======================================================================
*/



--Erase SHTUYOT data:
---------------------
UPDATE [dbo].[T01IndHesbon]
	SET txtEmail1 = NULL, txtEmail2 = NULL, txtEmail3 = NULL, txtEmail4 = NULL, txtEmail5 = NULL, txtBagEmail1 = NULL,
		txtBagEmail2 = NULL, txtBagEmail3 = NULL, txtBagEmail4 = NULL
GO






/*
[ifhRama] varchar(1) CHECK(ifhRama >'0' And ifhRama < '4') NOT NULL,
ALTER TABLE [dbo].[ezrErrorLog] ADD DEFAULT (CONVERT([varchar](10),GETDATE(),(23))) FOR [mkDate]
GO
ALTER TABLE [dbo].[ezrErrorLog] ADD DEFAULT (CONVERT([varchar](8),GETDATE(),(108))) FOR [mkTime]
GO
SELECT (CONVERT([varchar](10),GETDATE(),(23))) AS theDate, (CONVERT([varchar](8),GETDATE(),(108))) AS theTime
*/



--FK's:
------
--T01KvuzotT01KvuzotPrimery
SELECT [dbo].[T01Kvuzot].*, [dbo].[T01KvuzotPrimery].[kvSug]
	FROM [dbo].[T01Kvuzot] LEFT JOIN [dbo].[T01KvuzotPrimery] ON [dbo].[T01KvuzotPrimery].[kvSug] = [dbo].[T01Kvuzot].[KvSugKvuza]
	WHERE [dbo].[T01KvuzotPrimery].[kvSug] IS NULL
GO
select * from [dbo].[T01KvuzotPrimery]
GO
INSERT INTO [dbo].[T01KvuzotPrimery] ([kvSug], [kvTeur]) SELECT N'ד', N'דיירים'
GO
ALTER TABLE [dbo].[T01Kvuzot] ADD CONSTRAINT [T01KvuzotT01KvuzotPrimery_FK] FOREIGN KEY([KvSugKvuza])
	REFERENCES [dbo].[T01KvuzotPrimery] ([kvSug])
		ON UPDATE CASCADE
GO

--T01PkudotT01PkudotKotrot
SELECT P.*
FROM [dbo].[T01Pkudot] P LEFT JOIN [dbo].[T01PkudotKotrot] PK ON PK.[pktSugPkuda] = P.pkuSug AND PK.[pktMisparPkuda] = P.[pkuMispar]
WHERE PK.[pktMisparPkuda] IS NULL
--If the are, delete.
GO
ALTER TABLE [dbo].[T01Pkudot] ADD CONSTRAINT [T01PkudotT01PkudotKotrot_FK] FOREIGN KEY([pkuSug], [pkuMispar])
	REFERENCES [dbo].[T01PkudotKotrot] ([pktSugPkuda], [pktMisparPkuda])
		ON UPDATE CASCADE
GO

--T02katParitimT02katRechesh
SELECT * FROM [dbo].[T02katRechesh]
	WHERE NOT EXISTS(SELECT * FROM [dbo].[T02katParitim] WHERE [katMisparParit] = [dbo].[T02katRechesh].[karMisparParit])
--If the are, delete.
SELECT * FROM [dbo].[T02katParitim] WHERE katMisparParit in(N'189', N'21125', N'5554', N'5555', N'70305', N'70535S', N'80125', N'802S')
GO
DELETE FROM [dbo].[T02katRechesh] WHERE karMisparParit  in(N'189', N'21125', N'5554', N'5555', N'70305', N'70535S', N'80125', N'802S')
GO
ALTER TABLE [dbo].[T02katRechesh] ADD CONSTRAINT [T02katRecheshT02katParitim_FK] FOREIGN KEY([karMisparParit])
	REFERENCES [dbo].[T02katParitim] ([katMisparParit])
		ON UPDATE CASCADE
GO

--T02katKniyotT02katParitim
SELECT * FROM [dbo].[T02katKniyot]
	WHERE NOT EXISTS(SELECT * FROM [dbo].[T02katParitim] WHERE [katMisparParit] = [dbo].[T02katKniyot].[kakMisparParit])
--If the are, delete.
ALTER TABLE [dbo].[T02katKniyot] ADD CONSTRAINT [T02katKniyotT02katParitim_FK] FOREIGN KEY([kakMisparParit])
	REFERENCES [dbo].[T02katParitim] ([katMisparParit])
		ON UPDATE CASCADE
GO

--T02KatHearotT02katParitim
SELECT * FROM [dbo].[T02KatHearot]
	WHERE NOT EXISTS(SELECT * FROM [dbo].[T02katParitim] WHERE [katMisparParit] = [dbo].[T02KatHearot].[kahMsKatalogi])
--If the are, delete.
ALTER TABLE [dbo].[T02KatHearot] ADD CONSTRAINT [T02KatHearotT02katParitim_FK] FOREIGN KEY([kahMsKatalogi])
	REFERENCES [dbo].[T02katParitim] ([katMisparParit])
		ON UPDATE CASCADE
GO

--T02mlyShurotT02Kotrot
SELECT * FROM [dbo].[T02mlyShurot]
	WHERE NOT EXISTS(SELECT * FROM [dbo].[T02Kotrot] WHERE kotSug = [dbo].[T02mlyShurot].mlySugReshuma AND kotASm = [dbo].[T02mlyShurot].mlyAsm1)
--examine and make decision about it.
DELETE FROM [dbo].[T02mlyShurot] WHERE mlyShurotCounter IN(232136, 239357, 341191)
GO
SELECT * FROM [dbo].[T02Kotrot] WITH (NOLOCK)
	WHERE kotASm IS NULL OR kotSug IS NULL
GO
--DROP INDEX T02Kotrot$ix_sug ON [dbo].[T02Kotrot];
--DROP INDEX T02Kotrot$ix_UQasmsug ON [dbo].[T02Kotrot];
--DROP INDEX T02Kotrot$ix_asm ON [dbo].[T02Kotrot];
--ALTER TABLE [dbo].[T02Kotrot] ALTER COLUMN [kotSug] nvarchar(3) NOT NULL
--GO
--ALTER TABLE [dbo].[T02Kotrot] ALTER COLUMN [kotASm] int NOT NULL
--GO
SELECT * FROM [dbo].[T02mlyShurot] WHERE [mlySugReshuma] IS NULL OR [mlyAsm1] IS NULL
GO
ALTER TABLE [dbo].[T02mlyShurot] ADD CONSTRAINT [T02mlyShurotT02Kotrot_FK] FOREIGN KEY ([mlySugReshuma], [mlyAsm1])
	REFERENCES [dbo].[T02Kotrot] ([kotSug], [kotASm])
		ON UPDATE CASCADE
GO

--T05RofimLakoahT05Rofim
SELECT * FROM dbo.T05RofimLakoah 
	WHERE NOT EXISTS(SELECT * FROM dbo.T01IndHesbon WHERE IndMsHeshbon = dbo.T05RofimLakoah.kshMsHeshbon)
--examine and make decision about it.
WITH noLak AS
(
SELECT * FROM dbo.T05RofimLakoah 
	WHERE NOT EXISTS(SELECT * FROM dbo.T01IndHesbon WHERE IndMsHeshbon = dbo.T05RofimLakoah.kshMsHeshbon)
)
DELETE FROM dbo.T05RofimLakoah 
	WHERE EXISTS(SELECT * FROM noLak WHERE noLak.kshMsHeshbon = dbo.T05RofimLakoah.kshMsHeshbon
					AND noLak.kshMsRofe = dbo.T05RofimLakoah.kshMsRofe)
GO

SELECT * FROM dbo.T05RofimLakoah 
	WHERE NOT EXISTS(SELECT * FROM dbo.T05Rofim WHERE rsrCounter = dbo.T05RofimLakoah.kshMsRofe)
--examine and make decision about it.
WITH noRof AS
(
SELECT * FROM dbo.T05RofimLakoah 
	WHERE NOT EXISTS(SELECT * FROM dbo.T05Rofim WHERE rsrCounter = dbo.T05RofimLakoah.kshMsRofe)
)
DELETE FROM dbo.T05RofimLakoah 
	WHERE EXISTS(SELECT * FROM noRof WHERE noRof.kshMsHeshbon = dbo.T05RofimLakoah.kshMsHeshbon
					AND noRof.kshMsRofe = dbo.T05RofimLakoah.kshMsRofe)
GO
ALTER TABLE [dbo].[T05RofimLakoah] ADD CONSTRAINT [T05RofimLakoahT05Rofim_FK] FOREIGN KEY ([kshMsRofe])
	REFERENCES [dbo].[T05Rofim] ([rsrCounter])
		ON UPDATE CASCADE
		ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T05RofimLakoah] ADD CONSTRAINT [T05RofimLakoahT01IndHesbon_FK] FOREIGN KEY ([kshMsHeshbon])
	REFERENCES [dbo].[T01IndHesbon] ([IndMsHeshbon])
		ON UPDATE CASCADE
		ON DELETE CASCADE
GO

-----------------------------------------------------------------------------------------------------------------------------
--Programming:
-----------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION [sps].[IsTrueBoolHaadafa] (@strKodReshuma nvarchar(6))
RETURNS bit
AS BEGIN
	DECLARE		@bitAnswer bit;

	SELECT		@bitAnswer = [hdYesNo]
		FROM	[dbo].[T10Haadafot] WITH (NOLOCK)
		WHERE	[hdSugReshuma] = @strKodReshuma;

	RETURN		ISNULL(@bitAnswer, 0);
END
GO
--SELECT [sps].[IsTrueBoolHaadafa](N'בשכ008') AS ans

CREATE FUNCTION [sps].[GiveNumHaadafa] (@strKodReshuma nvarchar(6))
RETURNS smallint
AS BEGIN
	DECLARE		@Answer smallint;

	SELECT		@Answer = [hdNumber]
		FROM	[dbo].[T10Haadafot] WITH (NOLOCK)
		WHERE	[hdSugReshuma] = @strKodReshuma;

	RETURN		@Answer;
END
GO
--SELECT [sps].[GiveNumHaadafa](N'tfl001') AS ans

CREATE FUNCTION [sps].[GivePathFromTezrPath] (@strkodPath nvarchar(16))
RETURNS nvarchar(300)
AS BEGIN
	DECLARE		@Answer nvarchar(300);

	SELECT		@Answer = [path]
		FROM	[dbo].[TezrPath] WITH (NOLOCK)
		WHERE	[kodPath] = @strkodPath

	RETURN		@Answer;
END
GO
--SELECT	[sps].[GivePathFromTezrPath] (N'erp_shen') AS ans
--SELECT	[sps].[GivePathFromTezrPath] (N'TavlaiFldr') AS ans
--SELECT	[sps].[GivePathFromTezrPath] (N'sdfsdfsdfsdf') AS ans

/*
-----------------------------------------------------------------
--CHANGE BY HAND!!!:
--------------------
--rename the following SP's - instead of sp_...., write usp_....
-----------------------------------------------------------------
sp_AddAndUpdateShilaOrders
sp_AddOneShenHaz
sp_ForGRData
sp_ForXLMeutzav
sp_SelectHazNumsByPo
sp_UpdateGorefMuzmanLe
sp_UpdateOneShenHaz
sp_UpdateReceivedShlav

sp_DoAboutDoubleT05rvShlavim -- ? there isn't such SP.
-----------------------------------------------------------------*/

CREATE VIEW dbo.vw_LaksInShenHazmanaScreen
AS
SELECT	IndMsHeshbon, IndShem, IndMsKvuza, IndPaturMaam, IndMhironYhudi, indMatehet, IndMatbea, indKodMahsan, IndMugbal
FROM	dbo.T01IndHesbon WITH (NOLOCK)
WHERE	IndMsKvuza IN (SELECT KvuMsKvuza FROM T01Kvuzot WHERE KvSugKvuza = N'ל') AND IndMugbal = 0
GO
--SELECT * FROM dbo.vw_LaksInShenHazmanaScreen ORDER BY IndMsHeshbon 

CREATE VIEW dbo.vwRofsInShenHazmanaScreen
AS
SELECT	rsrCounter, rsrShem, rsrMakomAvoda, [rsrPelephone], [doctorIdNum], [rsrHearotRofe]
FROM	[dbo].[T05Rofim] WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwRofsInShenHazmanaScreen

CREATE VIEW dbo.vwShlavimCbo
AS
SELECT	rslKodShlav, rslTeurShlav, rslKodOved, rslYemeyAvoda, rslEfyun
FROM	T05Shlavim WITH (NOLOCK)
GO
--cbo kod shlav: SELECT rslKodShlav, rslTeurShlav, rslKodOved, rslYemeyAvoda, rslEfyun FROM dbo.vwShlavimCbo ORDER BY rslKodShlav
--cbo name shlav: SELECT rslTeurShlav, rslKodShlav,rslKodOved, rslYemeyAvoda, rslEfyun FROM dbo.vwShlavimCbo ORDER BY rslTeurShlav

CREATE VIEW dbo.vwPratim
AS
SELECT	[rspKodPrat], [rspTeurPrat] 
FROM	dbo.T09Pratim WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwPratim ORDER BY rspKodPrat

CREATE VIEW dbo.vwMll
AS
SELECT	[mllKod], [mllTeur]
FROM	[dbo].[T09Melel] WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwMll ORDER BY [mllKod]

CREATE FUNCTION [sps].[fnFindMaam] (@dateForMaam datetime)
RETURNS float
AS BEGIN
	DECLARE		@wantedDate datetime, @floatResult float;
	SET			@wantedDate = ISNULL(@dateForMaam, GETDATE());
	SET			@wantedDate = CONVERT(datetime, (CONVERT(varchar(10),@wantedDate,(23))));
	SELECT		TOP 1 @floatResult = [maaRate]
		FROM	[dbo].[T01Maam]
		WHERE	[maaRate] IS NOT NULL
					AND [maaDate] <= @wantedDate
		ORDER BY [maaDate] DESC;
	RETURN		@floatResult;
END
GO /*
SELECT [sps].[fnFindMaam]('1976-08-01 15:26:35') AS 'maam';
SELECT [sps].[fnFindMaam]('') AS 'maam';
SELECT [sps].[fnFindMaam](NULL) AS 'maam'; */

--newInsertToErrorLog
--DECLARE @RetVal int, @RetErrNum int, @RetErrMsg nvarchar(4000)
--EXEC [sps].[usp_InsertToErrorLog] N'', NULL, N'טוב', @RetVal OUTPUT, @RetErrNum OUTPUT, @RetErrMsg OUTPUT
--PRINT CONVERT(nvarchar(700), ISNULL(@RetVal, '')) + ' ' + CONVERT(nvarchar(700), ISNULL(@RetErrNum, '')) + ' ' + ISNULL(@RetErrMsg, '')
--GO
CREATE PROC [sps].[usp_InsertToErrorLog]
	(@formName nvarchar(100), @description nvarchar(max), @notes nvarchar(max),
	 @RetVal int OUTPUT, @RetErrNum int OUTPUT, @RetErrMsg nvarchar(4000) OUTPUT)
AS BEGIN
	DECLARE @result int, @shlav varchar(120);
	SET XACT_ABORT, NOCOUNT ON

	SET @shlav = 'check arguments';
	-------------------------------
	IF LEN(ISNULL(@formName, '')) = 0 AND LEN(ISNULL(@description, '')) = 0 AND LEN(ISNULL(@notes, '')) = 0
		BEGIN
			SET @result = (-1); --missing data
			SET @RetErrMsg = N'חסר דאטה להזנת רשומה בהיסטוריית שגיאות.';
			SET @RetVal = @result;
			RETURN;
		END;
	SET @shlav = 'insert into ezrErrorLog';
	---------------------------------------
	BEGIN TRY
		BEGIN TRAN;
			INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes])
			VALUES (@formName, @description, @notes);
		COMMIT TRAN;
		SET @result = 1;
		SET @RetVal = @result;		
	END TRY
	BEGIN CATCH
		SET @RetErrNum = ERROR_NUMBER();
		SET @RetErrMsg = 'SQL Server - Database: ' + DB_NAME() + ' - Error in procedure ' + OBJECT_NAME(@@PROCID) + ' in shlav: ' + @shlav + '. Description: ' + ERROR_MESSAGE();
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
		SET @RetVal = (-4)
	END CATCH
END;
GO

CREATE VIEW dbo.vwItemsActiveCbo
AS
SELECT [katMisparParit], [katTeurParit], [katSivug]
FROM [dbo].[T02katParitim] WITH (NOLOCK)
WHERE [katNotActive] = 0
GO
--SELECT katMisparParit, katTeurParit, [katSivug] FROM dbo.vwItemsActiveCbo ORDER BY katMisparParit

--instead of Q05Signs
CREATE VIEW dbo.vwQ05Signs
AS
SELECT ZS.sgn_MsHazmana, ZS.sgn_MsShura, ZS.sgn_MsShen, S.sgn_Picture, S.sgn_Color
FROM T05TzlavSignes ZS LEFT JOIN T05Signes S ON ZS.sgn_MsSign = S.sgn_Number
GO
--SELECT * FROM dbo.vwQ05Signs WHERE sgn_MsHazmana = 33165

CREATE FUNCTION [dbo].[fnGetColsListFOrOpenjsonWithClause] (@tName sysname)
RETURNS nvarchar(MAX)
BEGIN
	DECLARE @ClmsList nvarchar(MAX), @objId int
	IF LEN(ISNULL(@tName, '')) = 0
		SET @ClmsList = N'No table name!'
	ELSE
		BEGIN
			SET @objId = OBJECT_ID(@tName)
			IF @objId IS NULL	
				SET @ClmsList = @tName + N' is NOT a recognizable object in this database.'
			ELSE
				BEGIN
					WITH theCols AS
					(
					SELECT TOP 100 PERCENT C.[name] + ' ' + T.[name] +
							CASE	WHEN C.system_type_id IN(231,239) THEN '(' + CASE WHEN C.max_length = (-1) THEN 'MAX' ELSE CONVERT(varchar(6), C.max_length / 2) END + ')'
									WHEN C.system_type_id IN(167,175) THEN '(' + CASE WHEN C.max_length = (-1) THEN 'MAX' ELSE CONVERT(varchar(6), C.max_length) END + ')'
									WHEN C.system_type_id IN(106,108) THEN '(' + CONVERT(varchar(6), C.precision) + ',' + CONVERT(varchar(6), C.scale) + ')'
									WHEN C.system_type_id = 165 THEN '(MAX)'
									ELSE ''
							END AS ColSpec
					FROM sys.columns C INNER JOIN sys.types T ON T.user_type_id = C.system_type_id
					WHERE C.object_id = @objId
					ORDER BY C.column_id
					)
					SELECT @ClmsList = COALESCE(@ClmsList + ', ' + ColSpec , ColSpec) FROM theCols
				END
		END
	RETURN @ClmsList
END
GO
--PRINT [dbo].[fnGetColsListFOrOpenjsonWithClause]('T05rvKotrot')
--GO
--SELECT [dbo].[fnGetColsListFOrOpenjsonWithClause]('T05rvKotrot') AS Cols
--GO
--SELECT [dbo].[fnGetColsListFOrOpenjsonWithClause]('NaNaNa') AS Cols
--GO
--SELECT [dbo].[fnGetColsListFOrOpenjsonWithClause]('') AS Cols
--GO
--SELECT [dbo].[fnGetColsListFOrOpenjsonWithClause](NULL) AS Cols
--GO

CREATE VIEW dbo.vwQ03mlyMInOutSofi
AS
WITH Q03mlyMInOut AS
(
SELECT mlyMisparParit AS no_parit, [mlyMahsan] AS mahsan,
	CASE WHEN [mlySugIdkun] = '1' THEN [mlyKamut] ELSE 0 END AS Incoming,
	CASE WHEN [mlySugIdkun] = '2' THEN [mlyKamut] ELSE 0 END AS Outgoing
FROM dbo.T02mlyShurot WITH (NOLOCK) --?
WHERE mlySugIdkun IN ('1','2')
)
SELECT no_parit, mahsan, SUM(Incoming) AS SumIn, SUM(Outgoing) AS SumOut
FROM Q03mlyMInOut
GROUP BY no_parit, mahsan
GO
--SELECT * FROM dbo.vwQ03mlyMInOutSofi ORDER BY no_parit, mahsan
--SELECT * FROM dbo.vwQ03mlyMInOutSofi WHERE no_parit = '01001' AND mahsan = '65' ORDER BY no_parit, mahsan

CREATE PROC [sps].[usp_FixT02YtrotMly] --for internal use
AS BEGIN
	--DECLARE @result int, @shlav varchar(120);
	SET XACT_ABORT, NOCOUNT ON
	BEGIN TRY
		BEGIN TRAN;
			MERGE INTO [dbo].[T02YtrotMly] AS trg
				USING (SELECT * FROM dbo.vwQ03mlyMInOutSofi) AS src
					ON trg.[ymlMsParit] = src.no_parit AND trg.[ymlMahsan] = src.mahsan
			WHEN MATCHED THEN UPDATE SET
				trg.[ymlTotKnisot] = src.SumIn, trg.[ymlTotYeziot] = src.SumOut
			WHEN NOT MATCHED BY TARGET THEN INSERT (ymlMahsan, ymlMsParit, ymlYtra, ymlTotKnisot, ymlTotYeziot)
				VALUES (src.mahsan, src.no_parit, 0, SumIn, SumOut);
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes])
			VALUES (DB_NAME() + '.' + OBJECT_NAME(@@PROCID), 'Error ' + CONVERT(nvarchar(25), ERROR_NUMBER()), ERROR_MESSAGE());
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
	END CATCH
END;
GO
--EXEC [sps].[usp_FixT02YtrotMly];

--Quantities for Bakarat-Mly
CREATE FUNCTION [sps].[KamutInMahsan] (@mahsan nvarchar(3), @parit nvarchar(24))
RETURNS int
AS BEGIN
	DECLARE	@qtyInMahsan int;
	IF @mahsan IS NULL OR @parit IS NULL
		SET @qtyInMahsan = NULL
	ELSE
		SELECT @qtyInMahsan = CONVERT(int, ISNULL([ymlYtra], 0)) + ISNULL([ymlTotKnisot], 0) - ISNULL([ymlTotYeziot], 0)
		FROM [dbo].[T02YtrotMly] WITH (NOLOCK)
		WHERE [ymlMahsan] = @mahsan AND [ymlMsParit] = @parit;
	RETURN @qtyInMahsan;
END
GO
--SELECT [sps].[KamutInMahsan]('25', '146') AS qty
--GO
ALTER FUNCTION [sps].[KamutInOpenHazs] (@customer int, @parit nvarchar(24))
RETURNS int
AS BEGIN
	DECLARE	@qtyInOpenHazs int;
	IF @customer IS NULL OR @parit IS NULL
		SET @qtyInOpenHazs = 0
	ELSE
		SELECT @qtyInOpenHazs = CONVERT(int, SUM([rsdKamut]))
		FROM [dbo].[T05rvShurot] S INNER JOIN [dbo].[T05rvKotrot] K
			ON K.rskMsHazmana = S.rsdMsHazmana
		WHERE K.[rskMsHeshbon] = @customer AND K.[rskSagur] = 0 AND S.[rsdMsKatalogi] = @parit AND S.[rsdSagur] = 0;
	RETURN ISNULL(@qtyInOpenHazs, 0);
END
GO
--SELECT [sps].[KamutInOpenHazs](0,0) AS qty
--GO

--for findPricePercent
CREATE FUNCTION [dbo].[fnFindPricePercent] (@makat nvarchar(24), @numLak int)
RETURNS TABLE AS RETURN
	WITH prtThings AS
	(
		SELECT	P.[katMisparParit], P.[katTeurParit], P.[katTeurLOazi], P.[katMehir], 
				P.[katMehirMatah], P.[katKodMatbea], P.[katIfun1]
		FROM	[dbo].[T02katParitim] P WITH (NOLOCK)
		WHERE	P.[katMisparParit] = @makat
	),
	lakThings AS
	(
		SELECT	I.[IndMsHeshbon], I.[IndMhironYhudi], I.[IndAhuzHanaha]			
		FROM	[dbo].[T01IndHesbon] I WITH (NOLOCK)
		WHERE	I.[IndMsHeshbon] = @numLak
	),
	mehironThings AS
	(
		SELECT	M.[ronMsMehiron], M.[ronMsKatalogi], M.[ronMehirYhudi], M.[ronAhuzYhudi], M.[ronMatbea], M.[ronHamasa]
		FROM	lakThings LEFT JOIN [dbo].[T03Mehironim] M WITH (NOLOCK) 
					ON M.[ronMsMehiron] = lakThings.IndMhironYhudi
		WHERE	M.[ronMsKatalogi] = @makat
	)
	SELECT	prtThings.*, lakThings.*, mehironThings.*
	FROM	prtThings OUTER APPLY lakThings 
				LEFT JOIN mehironThings ON mehironThings.ronMsMehiron = lakThings.IndMhironYhudi
GO
--SELECT * FROM [dbo].[fnFindPricePercent]('666666', 2136)
--GO
--SELECT * FROM [dbo].[fnFindPricePercent]('01001', 2136)
--GO
--SELECT * FROM [dbo].[fnFindPricePercent]('01001', 3623)
--GO
--SELECT * FROM [dbo].[fnFindPricePercent]('01001', NULL)
--GO


--fnF02SubListMHR
CREATE FUNCTION [dbo].[fnF02SubListMHR] (@numMehiron int)
RETURNS TABLE AS RETURN
	SELECT	P.katTeurParit, P.katMisparParit, M.ronMsMehiron,
			CONVERT(money,
				CONVERT(decimal(25,13), M.ronMehirYhudi) - 
					(CONVERT(decimal(25,13), M.ronMehirYhudi) * CONVERT(decimal(25,13), ISNULL(M.ronAhuzYhudi, 0)) / CONVERT(decimal(25,13), 100))
			) AS netto, M.ronHamasa 
	FROM	dbo.T03Mehironim M WITH (NOLOCK) INNER JOIN T02katParitim P WITH (NOLOCK) ON M.ronMsKatalogi = P.katMisparParit
	WHERE	M.ronMsMehiron = @numMehiron
GO
--SELECT * FROM [dbo].[fnF02SubListMHR](120) ORDER BY [katMisparParit]
--GO
--SELECT * FROM [dbo].[fnF02SubListMHR](NULL) ORDER BY [katMisparParit]
--GO

CREATE VIEW dbo.vwItems05Screen
AS
SELECT	P.katMisparParit, P.katTeurParit, P.katTeurYehida, P.katMehir, P.katIfun1, P.katIfun2, P.katIfun3, 
		P.katSugMehira, R.karMehirMummlaz, P.katKodShlav, P.katNotActive
FROM	dbo.T02katParitim P WITH (NOLOCK)			
			LEFT JOIN dbo.T02katRechesh R WITH (NOLOCK) ON R.karMisparParit = P.katMisparParit
GO
--SELECT * FROM dbo.vwItems05Screen ORDER BY katMisparParit

CREATE VIEW dbo.vwColorByItm1Ifun
AS
SELECT	[ifpkod], [itsColor]
FROM	[dbo].[T02IfunPar] WITH (NOLOCK)
WHERE	[ifpKodRama] ='1'
GO
--SELECT * FROM dbo.vwColorByItm1Ifun

CREATE VIEW dbo.vwItems05ScreenWCOLOR
AS
SELECT	P.katMisparParit, P.katTeurParit, P.katTeurYehida, P.katMehir, P.katIfun1, P.katIfun2, P.katIfun3, 
		P.katSugMehira, R.karMehirMummlaz, P.katKodShlav, P.katNotActive, C.itsColor
FROM	dbo.T02katParitim P WITH (NOLOCK)			
			LEFT JOIN dbo.T02katRechesh R WITH (NOLOCK) ON R.karMisparParit = P.katMisparParit
			LEFT JOIN dbo.vwColorByItm1Ifun C ON C.ifpkod = P.katIfun1
GO
--SELECT * FROM dbo.vwItems05ScreenWCOLOR

--ifun parit query simple
CREATE VIEW dbo.vwIfyunPritimCbo
AS
SELECT [ifpkod], [ifpteur], [ifpKodRama]
FROM [dbo].[T02IfunPar] WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwIfyunPritimCbo

CREATE VIEW dbo.vwQForComboMsLak
AS
SELECT	H.IndMsHeshbon, H.IndShem, H.IndMsKvuza, H.IndTelefon, 
		H.IndPelefon, H.IndKodAshray, H.IndYemeyAshrai, H.IndMhironYhudi, 
		H.IndSochen, H.IndMugbal, H.IndPaturMaam, H.IndHeara, 
		K.KvSugKvuza, H.IndAhuzHanaha
FROM	dbo.T01IndHesbon H WITH (NOLOCK) LEFT JOIN T01Kvuzot K WITH (NOLOCK) ON H.IndMsKvuza = K.KvuMsKvuza
WHERE	H.IndMugbal = 0
GO
--SELECT * FROM dbo.vwQForComboMsLak ORDER BY IndMsHeshbon


CREATE VIEW dbo.vwRofsByLak
AS
SELECT	R.rsrCounter, R.rsrShem, R.rsrMakomAvoda, RL.kshMsHeshbon
FROM	dbo.T05Rofim R WITH (NOLOCK) INNER JOIN dbo.T05RofimLakoah RL WITH (NOLOCK)
			ON RL.kshMsRofe = R.rsrCounter
GO
--SELECT rsrCounter, rsrShem, rsrMakomAvoda, kshMsHeshbon FROM dbo.vwRofsByLak WHERE kshMsHeshbon = 1050 ORDER BY rsrCounter

CREATE VIEW dbo.vwMahsanCbo
AS
SELECT	[KodMahsan], [ShemMahsan]
FROM [dbo].[T09Mahsanim] WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwMahsanCbo ORDER BY [KodMahsan]

CREATE VIEW dbo.vwCboSochs
AS
SELECT [MsSochen], [ShemSochen]
FROM [dbo].[T09Sochnim] WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwCboSochs ORDER BY [MsSochen]

--for Q01YtratHeah ytrat Heshbon!!:
CREATE VIEW dbo.vwQ01YtratHeah
AS
WITH YtratHeah AS
(
SELECT		H.IndMsHeshbon AS msHeshbon, Y.ytfYtratPtiha AS ptiha, 
			SUM(CASE WHEN T.[TnfKodHZ] = '1' THEN (T.[TnfSchum] * (-1)) ELSE T.[TnfSchum] END) AS tnuot
FROM		dbo.T01IndHesbon H WITH (NOLOCK) LEFT JOIN dbo.T01Ytrot Y WITH (NOLOCK) ON H.IndMsHeshbon = Y.ytfMsHeshbon 
				LEFT JOIN dbo.T01Tnuot T WITH (NOLOCK) ON H.IndMsHeshbon = T.TnfMsHeshbon
GROUP BY	H.IndMsHeshbon, Y.ytfYtratPtiha
)
SELECT	msHeshbon, ptiha, tnuot, ISNULL(ptiha, 0) + ISNULL(tnuot, 0) AS YtratHeshbon
FROM	YtratHeah
GO
--SELECT * FROM dbo.vwQ01YtratHeah ORDER BY msHeshbon
--GO
--SELECT * FROM dbo.vwQ01YtratHeah WHERE msHeshbon = 1000
--GO

CREATE VIEW dbo.QForCboKesher
AS
SELECT	[ksrShem], [ksrLakoah], [ksrNumSort]
FROM	dbo.T09Kesher WITH (NOLOCK)
WHERE	ksrSugLakoah = N'ח'
GO
--SELECT [ksrShem], [ksrLakoah], [ksrNumSort] FROM dbo.QForCboKesher WHERE [ksrLakoah] = 1001 ORDER BY ksrNumSort
--GO

-------------------------------------------------------------------------------------------------------------------------
--SP for creating Hatzaat-mehir to customer:
--------------------------------------------
--sps.usp_AddOneHatzaa, adLongVarWChar, jsonKot, adLongVarWChar, jsonLines)
--tasks:
--bdikot JSONs
--bdikot data
--calc money
--findNewNumber(Me.kotSug)
--metupal (=his name) will be sent. if it is NOT "hazaa lelo metupal" - it should be inserted into metupalim table (if KotMsMetupal is still Null) and his name <> cboHeshbonName.
--KodRofe.Value = IIf(IsNull(KodRofe.Value), "0", KodRofe.Value)
--insert into T02Kotrot:
--(KotMetupal, KotMsMetupal, KodRofe, kotSug, kotASm, kotAsm2, kotMsHeshbon, kotMsSohen, kotTarich, kotErech,
--kotShumShurot = calc in SQL!,
--kotAhuz1, kotSchum1, kotAhuz2, kotSchum2, kotMaam = calc in SQL!, kotTotal = calc in SQL!,
--kotMahsan, kotAsmLakoah, kotIshKesher, kotHerara, kotKod1, kotKod2, kotKod3, kotMll1, kotMll2)
--insert into T02mlyShurot:
--(mlyMisparParit, mlySugReshuma, mlyAsm1, mlyMsShura, mlyMsHeshbon, mlyMahsan, mlyTarich, mlyKamut, mlySugIdkun = '0',
--mlyMehir, mlyAhuz, mlySugAsmMakor, mlyMsAsmMakor, mlyMsShuraMakor, mlyMemo, mlyNumShinaim
--close kotrot-makor and shurot-makor like in b.hashen


CREATE FUNCTION [sps].[IsPaturMaam] (@customer int)
RETURNS bit
AS BEGIN
	DECLARE	@bitPaturMaam bit, @sugHev int;

	--take from [dbo].[T01Hevra]
	SELECT @sugHev = ISNULL([adgSugCompany], 1) FROM [dbo].[T01Hevra] WHERE [agdId] IS NOT NULL;
	SET @bitPaturMaam = CASE WHEN @sugHev = 2 THEN 1 WHEN @sugHev = 3 THEN 1 ELSE 0 END;
	--take from [dbo].[T01IndHesbon]
	IF @customer IS NOT NULL AND @bitPaturMaam = 0
			SELECT @bitPaturMaam = [IndPaturMaam] FROM [dbo].[T01IndHesbon] WHERE [IndMsHeshbon] = @customer;
	
	RETURN @bitPaturMaam;
END
GO
--SELECT [sps].[IsPaturMaam](11)
--GO

CREATE FUNCTION [sps].[fnFindNewNumber] (@kotSug nvarchar(3))
RETURNS int
AS BEGIN
	DECLARE @lastAsmFromSugim int, @gadolForward int;

	IF @kotSug IS NULL
		RETURN NULL;

	IF NOT EXISTS(SELECT * FROM dbo.T02Sugim WHERE sgmSugMismach = @kotSug)
		RETURN NULL;

	SELECT @lastAsmFromSugim = ISNULL(sgmLast, ISNULL(sgmStarter, 1)) 
		FROM dbo.T02Sugim 
		WHERE sgmSugMismach = @kotSug;
	
	IF @kotSug = N'prt'
		BEGIN
			IF NOT EXISTS(SELECT * FROM [dbo].[T02katParitim] WHERE [katMisparParit] = CONVERT(nvarchar(25), @lastAsmFromSugim))
				RETURN @lastAsmFromSugim;

			SELECT TOP(1) @gadolForward = TRY_CONVERT(int, [katMisparParit]) --ALWAYS exists because ([katMisparParit] EXISTS IN THIS SCOPE AND = @lastAsmFromSugim)
				FROM [dbo].[T02katParitim] T1
				WHERE ISNUMERIC([katMisparParit]) = 1
				AND NOT EXISTS(SELECT * FROM [dbo].[T02katParitim] T2 WHERE TRY_CONVERT(int, T2.[katMisparParit]) = TRY_CONVERT(int, (T1.[katMisparParit] + 1))) 
					AND TRY_CONVERT(int, T1.[katMisparParit]) >= @lastAsmFromSugim 
				ORDER BY TRY_CONVERT(int, T1.[katMisparParit]);
		END
	ELSE
		BEGIN
			IF NOT EXISTS(SELECT * FROM [dbo].[T02Kotrot] WHERE [kotSug] = @kotSug AND [kotASm] = @lastAsmFromSugim)
				RETURN @lastAsmFromSugim;

			SELECT TOP(1) @gadolForward = [kotASm] --ALWAYS exists because ([kotASm] EXISTS IN THIS SCOPE AND = @lastAsmFromSugim)
				FROM [dbo].[T02Kotrot] T1
				WHERE NOT EXISTS(SELECT * FROM [dbo].[T02Kotrot] T2 WHERE T2.[kotSug] = @kotSug AND T2.[kotASm] = (T1.[kotASm] + 1)) 
					AND T1.[kotASm] >= @lastAsmFromSugim AND T1.[kotSug] = @kotSug 
				ORDER BY T1.[kotASm];
		END
	RETURN (@gadolForward + 1);
END
GO
--SELECT [sps].[fnFindNewNumber](N'צל') AS docNumber;
--SELECT [sps].[fnFindNewNumber](N'prt') AS prtNumber;
--GO

CREATE PROC [sps].[usp_SelectCalcAllNow] 
	(@patur bit = 0, @kotSug nvarchar(3), @kotTarich datetime, @kotShumShurot decimal(25,13), @kotAhuz1 decimal(25,13),
	 @kotAhuz2 decimal(25,13), @SumYadani decimal(25,13))
AS BEGIN
	DECLARE @sugIgul tinyint , @maamRate decimal(25,13), @newkotSchum1 decimal(25,13), @afterDiscount1 decimal(25,13);
	DECLARE @newkotSchum2 decimal(25,13), @afterDiscount2 decimal(25,13), @newkotMaam decimal(25,13);
	DECLARE @newkotTotal decimal(25,13), @useYadaniAsTotal bit = 0, @tempTotal decimal(25,13), @newkotAhuz1 decimal(25,13);

	SET XACT_ABORT, NOCOUNT ON	
	BEGIN TRY
		--set @sugIgul - sug igul: 1 = round to tenths of sheqels. 2 = round to half. 3 = round to shalem. else = don't round.
		SELECT @sugIgul = ISNULL([sgmIgul], 0) FROM [dbo].[T02Sugim] WITH (NOLOCK) WHERE [sgmSugMismach] = @kotSug;
		--maam rate
		IF @patur = 1
			SET @maamRate = 0
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
		--return table with values for document's-koteret:
		SELECT	ISNULL(@newkotSchum1, 0) AS 'newkotSchum1', ISNULL(@newkotSchum2, 0) AS 'newkotSchum2', 
				ISNULL(@newkotMaam, 0) AS 'newkotMaam', ISNULL(@newkotTotal, 0) AS 'newkotTotal', @newkotAhuz1 AS 'ahuz1IfYadani';
	END TRY
	BEGIN CATCH
		SELECT NULL AS 'newkotSchum1', NULL AS 'newkotSchum2', NULL AS 'newkotMaam', NULL AS 'newkotTotal';
		INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes])
			VALUES (DB_NAME() + '.' + OBJECT_NAME(@@PROCID), 'Error ' + CONVERT(nvarchar(25), ERROR_NUMBER()), ERROR_MESSAGE());
	END CATCH
END;
GO
--(@patur bit = 0, @kotSug nvarchar(3), @kotTarich datetime, @kotShumShurot decimal(25,13), @kotAhuz1 decimal(25,13),
--	 @kotAhuz2 decimal(25,13), @SumYadani decimal(25,13))
--EXEC [sps].[usp_SelectCalcAllNow] 0, N'צל', NULL, 299, 12, 5, 280
--GO

CREATE PROC [sps].[usp_AddOneHatzaa] 
	(@jsonKot nvarchar(MAX), @jsonLines nvarchar(MAX), 
	 @RetVal int OUTPUT, @RetErrNum int OUTPUT, @RetErrMsg nvarchar(4000) OUTPUT)
AS
BEGIN
	DECLARE @docNumber int --@RetVal - if all goes well - eventually should be equal to @docNumber!
	DECLARE @result int, @shlav varchar(60), @tempInt int, @MsHeshbonTmp int
	DECLARE @dealWithMakor bit, @matah bit, @patur bit, @metupalTmp nvarchar(30), @numMetupalTmp int;
	DECLARE @kotSug nvarchar(3), @kotTarich datetime, @kotShumShurot decimal(25,13), @kotAhuz1 decimal(25,13), @kotAhuz2 decimal(25,13), @SumYadani decimal(25,13);
	
	SET XACT_ABORT, NOCOUNT ON		
	SET @shlav = 'check JSON arguments';
	IF LEN(ISNULL(@jsonKot,'')) = 0 OR LEN(ISNULL(@jsonLines,'')) = 0
		BEGIN
			SET @result = (-1); --missing data
			SET @RetErrMsg = N'חסר דאטה להזנת כותרת/שורות הצעה.';
			SET @RetVal = @result;
			RETURN;
		END;
	SET @shlav = 'check JSON KOT valid';
	IF ISJSON(@jsonKot) = 0
		BEGIN
			SET @result = (-33); --JSON not valid
			SET @RetErrMsg = N'דאטה לא חוקי להזנת כותרת הצעה.';
			SET @RetVal = @result;
			RETURN;
		END;
	SET @shlav = 'check JSON Lines valid';
	IF ISJSON(@jsonLines) = 0
		BEGIN
			SET @result = (-33); --JSON not valid
			SET @RetErrMsg = N'דאטה לא חוקי להזנת שורות הצעה.';
			SET @RetVal = @result;
			RETURN;
		END;

	BEGIN TRY
		SET @shlav = 'set some options';
		SET @matah = 0;

		SET @shlav='prepare temp table for koteret-Hatzaa';
		IF OBJECT_ID('tempdb..#TmpT02Kotrot') IS NOT NULL
			DROP TABLE #TmpT02Kotrot;
		CREATE TABLE #TmpT02Kotrot
		(	KotMetupal nvarchar(30),
			KotMsMetupal int,
			KodRofe int,
			kotSug nvarchar(3),
			kotASm int,
			kotAsm2 int,
			kotMsHeshbon int,
			kotMsSohen int,
			kotTarich datetime,
			kotErech datetime,
			kotShumShurot decimal(25,13),
			kotAhuz1 decimal(25,13),
			kotSchum1 decimal(25,13),
			kotAhuz2 decimal(25,13),
			kotSchum2 decimal(25,13),
			kotMaam decimal(25,13),
			kotTotal decimal(25,13),
			kotMahsan nvarchar(3),
			kotAsmLakoah nvarchar(30),
			kotIshKesher nvarchar(50),
			kotHerara nvarchar(MAX),
			kotKod1 nvarchar(3),
			kotKod2 nvarchar(3),
			kotKod3 nvarchar(3),
			kotMll1 nvarchar(3),
			kotMll2 nvarchar(3),
			SumYadani decimal(25,13),
			id int IDENTITY(1, 1) NOT NULL
		);
		SET @shlav='index temp table for koteret-Hatzaa';
		ALTER TABLE #TmpT02Kotrot ADD CONSTRAINT [TmpT02Kotrot$PK] PRIMARY KEY ([id]);
		SET @shlav='insert into temp table for koteret-Hatzaa from JSON';
		INSERT INTO #TmpT02Kotrot (KotMetupal, KotMsMetupal, KodRofe, kotSug, kotASm, kotAsm2, kotMsHeshbon, kotMsSohen, kotTarich, kotErech, kotShumShurot, kotAhuz1, kotSchum1, kotAhuz2, kotSchum2, kotMaam, kotTotal, kotMahsan, kotAsmLakoah, kotIshKesher, kotHerara, kotKod1, kotKod2, kotKod3, kotMll1, kotMll2, SumYadani)
			SELECT * FROM OpenJson(@jsonKot)
			WITH (KotMetupal nvarchar(30), KotMsMetupal int, KodRofe int, kotSug nvarchar(3), kotASm int, kotAsm2 int, kotMsHeshbon int, kotMsSohen int, kotTarich datetime, kotErech datetime, kotShumShurot decimal(25,13), kotAhuz1 decimal(25,13), kotSchum1 decimal(25,13), kotAhuz2 decimal(25,13), kotSchum2 decimal(25,13), kotMaam decimal(25,13), kotTotal decimal(25,13), kotMahsan nvarchar(3), kotAsmLakoah nvarchar(30), kotIshKesher nvarchar(50), kotHerara nvarchar(MAX), kotKod1 nvarchar(3), kotKod2 nvarchar(3), kotKod3 nvarchar(3), kotMll1 nvarchar(3), kotMll2 nvarchar(3), SumYadani decimal(25,13));
		SET @shlav='check if data exists in temp table for koteret-Hatzaa';
		IF NOT EXISTS(SELECT * FROM #TmpT02Kotrot WHERE id IS NOT NULL)
			BEGIN
				SET @result = (-1); --missing data
				SET @RetErrMsg = N'חסר דאטה ממשי להזנת כותרת הצעה.';
				SET @RetVal = @result;
				RETURN;
			END;

		SET @shlav='prepare temp table for shurot-Hatzaa';
		IF OBJECT_ID('tempdb..#TmpT02mlyShurot') IS NOT NULL
			DROP TABLE #TmpT02mlyShurot;
		CREATE TABLE #TmpT02mlyShurot
		(	mlyMisparParit nvarchar(24),
			mlySugReshuma nvarchar(3),
			mlyAsm1 int,
			mlyMsShura smallint,
			mlyMsHeshbon int,
			mlyMahsan nvarchar(3),
			mlyTarich datetime,
			mlyKamut decimal(25,13),
			mlySugIdkun varchar(1),
			mlyMehir decimal(25,13),
			mlyAhuz decimal(25,13),
			mlySugAsmMakor nvarchar(3),
			mlyMsAsmMakor int,
			mlyMsShuraMakor smallint,
			mlyMemo nvarchar(MAX),
			mlyNumShinaim nvarchar(200),
			id int IDENTITY(1, 1) NOT NULL
		);
		SET @shlav='index temp table for lines-Hatzaa';
		ALTER TABLE #TmpT02mlyShurot ADD CONSTRAINT [TmpT02mlyShurot$PK] PRIMARY KEY ([id]);
		SET @shlav='insert into temp table for lines-Hatzaa from JSON';
		INSERT INTO #TmpT02mlyShurot (mlyMisparParit, mlySugReshuma, mlyAsm1, mlyMsShura, mlyMsHeshbon, mlyMahsan, mlyTarich, mlyKamut, mlySugIdkun, mlyMehir, mlyAhuz, mlySugAsmMakor, mlyMsAsmMakor, mlyMsShuraMakor, mlyMemo, mlyNumShinaim)
			SELECT * FROM OpenJson(@jsonLines)
			WITH (mlyMisparParit nvarchar(24), mlySugReshuma nvarchar(3), mlyAsm1 int, mlyMsShura smallint, mlyMsHeshbon int, mlyMahsan nvarchar(3), mlyTarich datetime, mlyKamut decimal(25,13), mlySugIdkun varchar(1), mlyMehir decimal(25,13), mlyAhuz decimal(25,13), mlySugAsmMakor nvarchar(3), mlyMsAsmMakor int, mlyMsShuraMakor smallint, mlyMemo nvarchar(MAX), mlyNumShinaim nvarchar(200));
		SET @shlav='check if data exists in temp table for lines-Hatzaa';
		IF NOT EXISTS(SELECT * FROM #TmpT02mlyShurot WHERE id IS NOT NULL)
			BEGIN
				SET @result = (-1); --missing data
				SET @RetErrMsg = N'חסר דאטה ממשי להזנת שורות הצעה.';
				SET @RetVal = @result;
				RETURN;
			END;

		SET @shlav='Renumerate temp lines';
		WITH baseTmpLine AS
		(	SELECT id, mlyMsShura, ROW_NUMBER() OVER(ORDER BY mlyMsShura, id) AS 'rNum' 
			FROM #TmpT02mlyShurot WHERE id IS NOT NULL)
		UPDATE baseTmpLine SET mlyMsShura = rNum;

		--update #TmpT02Kotrot.kotShumShurot by SUM of #TmpT02mlyShurot.mlyKamut*mlyMehir-mlyAhuz/100*mlyKamut*mlyMehir
		SET @shlav='update sum-lines-money in temp Koteret';
		WITH totLine
		AS
		(
			SELECT	SUM(
						CONVERT(decimal(25,13), 
									(
										(ISNULL(mlyKamut, 0) * ISNULL(mlyMehir, 0)) - 
										(ISNULL(mlyKamut, 0) * ISNULL(mlyMehir, 0) * ISNULL(mlyAhuz, 0) / CONVERT(decimal(25,13), 100))
									)
								)
						) AS totShurot
			FROM	#TmpT02mlyShurot WHERE #TmpT02mlyShurot.id IS NOT NULL
		)
		UPDATE #TmpT02Kotrot SET #TmpT02Kotrot.kotShumShurot = (SELECT totLine.totShurot FROM totLine)
				WHERE #TmpT02Kotrot.id IS NOT NULL;

		SET @shlav = 'find if patur-maam';
		SELECT TOP(1) @MsHeshbonTmp = kotMsHeshbon FROM #TmpT02Kotrot WHERE id IS NOT NULL;
		SET @patur = [sps].[IsPaturMaam](@MsHeshbonTmp);

		--update schumim in #TmpT02Kotrot
		SET @shlav='update fields in temp Koteret';
		SELECT	@kotSug = [kotSug], @kotTarich = [kotTarich], @kotShumShurot = [kotShumShurot], @kotAhuz1 = [kotAhuz1], 
				@kotAhuz2 = [kotAhuz2], @SumYadani = [SumYadani]
			FROM #TmpT02Kotrot WHERE #TmpT02Kotrot.[id] IS NOT NULL;

		CREATE TABLE #TmpSchumim
		(newkotSchum1 decimal(25,13), newkotSchum2 decimal(25,13), newkotMaam decimal(25,13), newkotTotal decimal(25,13), ahuz1IfYadani decimal(25,13));
		INSERT INTO #TmpSchumim 
			EXEC [sps].[usp_SelectCalcAllNow] @patur, @kotSug, @kotTarich, @kotShumShurot, @kotAhuz1, @kotAhuz2, @SumYadani;

		UPDATE #TmpT02Kotrot SET kotSchum1 = TMP.[newkotSchum1], kotSchum2 = TMP.[newkotSchum2], 
			kotMaam = TMP.[newkotMaam], kotTotal = TMP.[newkotTotal], kotAhuz1 = ISNULL(TMP.[ahuz1IfYadani], #TmpT02Kotrot.[kotAhuz1])
			FROM #TmpT02Kotrot OUTER APPLY (SELECT TOP(1) * FROM #TmpSchumim WHERE [newkotTotal] IS NOT NULL) AS TMP
			WHERE #TmpT02Kotrot.[id] IS NOT NULL;

		SET @shlav='Check if there is source-doc';
		SET	@dealWithMakor = 0
		IF EXISTS(SELECT * FROM #TmpT02mlyShurot WHERE mlySugAsmMakor IS NOT NULL AND mlyMsAsmMakor IS NOT NULL AND mlyMsShuraMakor IS NOT NULL)
			SET	@dealWithMakor = 1;	
		
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
		BEGIN TRAN;
			SET @shlav='docNumber: find new number for the document';
			SELECT @docNumber = [sps].[fnFindNewNumber](@kotSug);
			IF @docNumber IS NULL
				BEGIN
					SET @result = (-3); --couldn't find asm for the order
					SET @RetErrMsg = N'המערכת לא הצליחה למצוא מספר אסמכתא חדש עבור המסמך.';
					SET @RetVal = @result;
					IF @@TRANCOUNT > 0
						ROLLBACK TRAN;
					RETURN;
				END;
			SET @shlav='Update T02Sugim';
			UPDATE [dbo].[T02Sugim] SET [sgmLast] = @docNumber WHERE [sgmSugMismach] = @kotSug;

			SET @shlav='UPDATE docNumber in temp tables';
			UPDATE #TmpT02Kotrot SET [kotASm] = @docNumber WHERE id IS NOT NULL;
			UPDATE #TmpT02mlyShurot SET [mlyAsm1] = @docNumber WHERE id IS NOT NULL;

			SET @shlav='Update table Metupalim';
			SELECT @metupalTmp = ISNULL([KotMetupal], ''), @numMetupalTmp = [KotMsMetupal]
				FROM #TmpT02Kotrot WHERE id IS NOT NULL;
			IF LEN(@metupalTmp) > 0 AND (@metupalTmp <> N'הצעה ללא מטופל')				
				IF @numMetupalTmp IS NULL
					BEGIN
						INSERT INTO [dbo].[T05Metupalim] ([rspShemMetupal]) SELECT @metupalTmp;
						SET @numMetupalTmp = SCOPE_IDENTITY();
						IF @numMetupalTmp IS NOT NULL UPDATE #TmpT02Kotrot SET [KotMsMetupal] = @numMetupalTmp WHERE id IS NOT NULL;
					END;			

			SET @shlav='Copy koteret from temp to real';
			INSERT INTO [dbo].[T02Kotrot] (KotMetupal, KotMsMetupal, KodRofe, kotSug, kotASm, kotAsm2, 
					kotMsHeshbon, kotMsSohen, kotTarich, kotErech, kotShumShurot, kotAhuz1, 
					kotSchum1, kotAhuz2, kotSchum2, kotMaam, kotTotal, kotMahsan, kotAsmLakoah, 
					kotIshKesher, kotHerara, kotKod1, kotKod2, kotKod3, kotMll1, kotMll2)
				SELECT KotMetupal, KotMsMetupal, KodRofe, kotSug, kotASm, kotAsm2, 
						kotMsHeshbon, kotMsSohen, kotTarich, kotErech, kotShumShurot, kotAhuz1, 
						kotSchum1, kotAhuz2, kotSchum2, kotMaam, kotTotal, kotMahsan, kotAsmLakoah, 
						kotIshKesher, kotHerara, kotKod1, kotKod2, kotKod3, kotMll1, kotMll2
				FROM #TmpT02Kotrot WHERE #TmpT02Kotrot.id IS NOT NULL;

			SET @shlav='Copy lines from temp to real';
			INSERT INTO [dbo].[T02mlyShurot] (mlyMisparParit, mlySugReshuma, mlyAsm1, mlyMsShura, mlyMsHeshbon, mlyMahsan, mlyTarich, mlyKamut, mlySugIdkun, mlyMehir, mlyAhuz, mlySugAsmMakor, mlyMsAsmMakor, mlyMsShuraMakor, mlyMemo, mlyNumShinaim)
				SELECT mlyMisparParit, mlySugReshuma, mlyAsm1, mlyMsShura, mlyMsHeshbon, mlyMahsan, mlyTarich, mlyKamut, mlySugIdkun, mlyMehir, mlyAhuz, mlySugAsmMakor, mlyMsAsmMakor, mlyMsShuraMakor, mlyMemo, mlyNumShinaim
				FROM #TmpT02mlyShurot WHERE #TmpT02mlyShurot.id IS NOT NULL;

			IF @dealWithMakor = 1
				BEGIN
					SET @shlav='Close Source Doc Lines';
					WITH baseWSrcLine AS
					(
					SELECT TS.mlyKamut AS 'tmpKamut', MS.mlyKamutBefoal, MS.mlyKamut, MS.mlySagur
					FROM #TmpT02mlyShurot TS INNER JOIN dbo.T02mlyShurot MS 
						ON MS.mlyAsm1 = TS.mlyMsAsmMakor AND MS.mlySugReshuma = TS.mlySugAsmMakor AND MS.mlyMsShura = TS.mlyMsShuraMakor
					WHERE TS.mlySugAsmMakor IS NOT NULL AND TS.mlyMsAsmMakor IS NOT NULL AND TS.mlyMsShuraMakor IS NOT NULL
					)
					UPDATE baseWSrcLine SET [mlyKamutBefoal] = ISNULL([mlyKamutBefoal], 0) + ISNULL([tmpKamut], 0), 
						[mlySagur] = CASE WHEN ISNULL([mlyKamutBefoal], 0) + ISNULL([tmpKamut], 0) >= ISNULL([mlyKamut], 0) THEN 1 ELSE [mlySagur] END;
					SET @shlav='Close Source Doc Header';	
					UPDATE dbo.T02Kotrot SET kotPatuah = 1 WHERE kotPatuah = 0 AND
						EXISTS(SELECT * FROM #TmpT02mlyShurot WHERE mlySugAsmMakor = dbo.T02Kotrot.kotSug 
										AND mlyMsAsmMakor = dbo.T02Kotrot.kotASm)
						AND NOT EXISTS(SELECT * FROM dbo.T02mlyShurot 
											WHERE mlySugReshuma = dbo.T02Kotrot.kotSug 
											AND mlyAsm1 = dbo.T02Kotrot.kotASm 
											AND mlyNo = 0 And mlySagur = 0);
				END;
		COMMIT TRAN;
		SET @result = @docNumber; --the number of the new order
		SET @RetVal = @result;
	END TRY
	BEGIN CATCH	
		SET @RetErrNum = ERROR_NUMBER();
		SET @RetErrMsg = 'SQL Server - Database: ' + DB_NAME() + ' - Error in procedure ' + OBJECT_NAME(@@PROCID) + ' in shlav: ' + @shlav + '. Description: ' + ERROR_MESSAGE();
		SET @RetVal = (-4)
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
		INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes])
			VALUES (DB_NAME() + '.' + OBJECT_NAME(@@PROCID), 'Error ' + CONVERT(nvarchar(25), ERROR_NUMBER()), ERROR_MESSAGE());
	END CATCH
END;
GO

CREATE VIEW dbo.vwF05ListLakohot
AS
SELECT	I.IndMsHeshbon, I.IndMsKvuza, I.IndShem, I.Indtovet, I.IndIr, I.IndTelefon, I.IndPelefon, I.indKazar, 
		I.IndTarichSgira, I.IndFax, I.IndMugbal, I.IndSpecialColor, I.indKodMahsan,
		CASE WHEN Y.YtratHeshbon IS NULL THEN NULL ELSE ((-1) * Y.YtratHeshbon) END AS 'theYtra'
FROM	dbo.T01IndHesbon I WITH (NOLOCK) LEFT JOIN dbo.vwQ01YtratHeah Y ON Y.msHeshbon = I.IndMsHeshbon 
WHERE	IndMsKvuza IN (SELECT KvuMsKvuza FROM T01Kvuzot WHERE KvSugKvuza = N'ל')
GO
--SELECT * FROM dbo.vwF05ListLakohot ORDER BY IndMsHeshbon
--GO

CREATE VIEW dbo.vwAllLaks
AS
SELECT	IndMsHeshbon, IndShem, IndMsKvuza, IndMugbal, IndIfun1
FROM	dbo.T01IndHesbon I WITH (NOLOCK)
WHERE	IndMsKvuza IN (SELECT KvuMsKvuza FROM T01Kvuzot WHERE KvSugKvuza = N'ל')
GO
--SELECT * FROM dbo.vwAllLaks ORDER BY IndMsHeshbon
--GO

CREATE VIEW dbo.HeshbonotFilterYourself
AS
SELECT	I.IndMsHeshbon, I.IndShem, I.IndMsKvuza, I.Indtovet, I.IndIr, I.IndTelefon, I.IndPelefon, 
		I.IndHeara, I.IndMugbal, I.IndTarichSgira, K.KvSugKvuza
FROM	T01IndHesbon I WITH (NOLOCK) LEFT JOIN [dbo].[T01Kvuzot] K WITH (NOLOCK)
		ON K.KvuMsKvuza = I.IndMsKvuza
GO
--SELECT * FROM dbo.HeshbonotFilterYourself ORDER BY IndMsHeshbon
--GO

CREATE VIEW dbo.vwF05ListPatients
AS
SELECT rspMisMetupal, rspShemMetupal, rspMsZehuy, rspMsIshi, rspKtovetMetupal, rspTelFonMetupal, rspTarihLida, rspMinMetupal 
FROM dbo.T05Metupalim WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwF05ListPatients ORDER BY rspMisMetupal

--selectFromProc("sps.usp_UpdatePatientNameWhereNexessary", adInteger, num, adVarWChar, TempVars("ShemMetupal").Value, adVarWChar, TempVars("newOvdNivName"))

CREATE TABLE [dbo].[T05rvMakav] ALTER COLUMN [rsmMemo] nvarchar(MAX) NULL
GO

CREATE PROC [sps].[usp_UpdatePatientNameWhereNexessary] (@patientNumber int, @NEWPatientName nvarchar(30), @workerName nvarchar(20))
AS
BEGIN
	DECLARE @shlav varchar(60), @dateSofi datetime, @theMemo nvarchar(MAX);
	DECLARE @locTable table (haz int, numPat int, oldPatName nvarchar(30), newPatName nvarchar(30));
	DECLARE @RetVal int, @RetErrNum int, @RetErrMsg nvarchar(4000);
	
	SET XACT_ABORT, NOCOUNT ON;
	SELECT @RetVal = 0, @RetErrNum = NULL, @RetErrMsg = NULL;
	SET @shlav = 'check arguments';
	-------------------------------
	IF ISNULL(@patientNumber, 0) = 0 OR LEN(ISNULL(@NEWPatientName, N'')) = 0
		BEGIN
			SELECT NULL AS nothingHere;
			SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
			RETURN;
		END;

	BEGIN TRY
		SET @shlav = 'find rows to work on';
		------------------------------------
		INSERT INTO @locTable (haz, numPat, oldPatName, newPatName)
			SELECT	 [rskMsHazmana], [rskMsMetupal], [rskMeupal], @NEWPatientName
			FROM	 [dbo].[T05rvKotrot]
			WHERE	 [rskMsMetupal] = @patientNumber AND ISNULL([rskMeupal], N'') <> @NEWPatientName
			ORDER BY [rskMsHazmana];
		IF NOT EXISTS(SELECT * FROM @locTable WHERE haz IS NOT NULL)
			BEGIN				
				SELECT NULL AS nothingHere;
				SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
				RETURN;
			END;

		BEGIN TRAN;
			SET @shlav = 'replace patient name in T05rvKotrot';
			---------------------------------------------------
			UPDATE K SET [rskMeupal] = L.newPatName
				FROM [dbo].[T05rvKotrot] K INNER JOIN @locTable L ON L.haz = K.rskMsHazmana
				WHERE K.[rskMsMetupal] = L.numPat AND ISNULL(K.[rskMeupal], N'') <> L.newPatName;

			SET @shlav = 'write to maakav';
			-------------------------------
			SET @dateSofi = CONVERT(VARCHAR(10), GETDATE(), 23);
			SET @theMemo = N'שינוי שם מטופל מספר ' + CONVERT(nvarchar(28), @patientNumber);
			IF LEN(ISNULL(@workerName, N'')) > 0
				SET @theMemo = @theMemo + N' על-ידי ' + @workerName;
			SET @theMemo = @theMemo + N' במסך מטופלים. ';
			INSERT INTO [dbo].[T05rvMakav] ([rsmMsHazmana], [rsmTarichKnisa], [rsmMemo])
				SELECT LOC.haz, @dateSofi, @theMemo + N'שם קודם: ' + ISNULL(LOC.oldPatName, N'[ריק]') + 
						N', שם חדש: ' + LOC.newPatName
				FROM @locTable LOC;

			SET @shlav='return and select';
			-------------------------------		
			SET @RetVal = 1;
			SELECT * FROM @locTable ORDER BY haz;			
			SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
		SET @shlav='commit transaction';
		--------------------------------
		COMMIT TRAN;
	END TRY
	BEGIN CATCH	
		SET @RetErrNum = ERROR_NUMBER();
		SET @RetErrMsg = 'SQL Server - Database: ' + DB_NAME() + ' - Error in procedure ' + OBJECT_NAME(@@PROCID) + ' in shlav: ' + @shlav + '. Description: ' + ERROR_MESSAGE();		
		SET @RetVal = (-4);
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
		INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes])
			VALUES (DB_NAME() + '.' + OBJECT_NAME(@@PROCID), 'Error ' + CONVERT(nvarchar(25), ERROR_NUMBER()), ERROR_MESSAGE());
		SELECT NULL AS nothingHere;
		SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
	END CATCH
END;
GO
--SELECT * FROM T05Metupalim WHERE rspMisMetupal = 167843
--SELECT * FROM T05rvKotrot WHERE rskMsMetupal = 167843 --199454 מיכאל ריבקין
--SELECT * FROM T05rvMakav WHERE rsmMsHazmana = 199454 ORDER BY rsmCounter DESC;
--EXEC [sps].[usp_UpdatePatientNameWhereNexessary] 167843, N'קקדו', N'נעם';
--GO

CREATE VIEW dbo.vwMetupalDox
AS
SELECT	K.rskMeupal, K.rskMsHazmana, K.rskTarichKabala, K.rskMuzmanLetarich, S.rsdMsKatalogi, S.rsdMemo, 
		S.rsdKamut, S.rsdMehir, S.rsdAhuz, S.rsdNumShinaim, K.rskSagur, K.rskMsMetupal, CONVERT(int, 1) AS 'ThisYear', 
		K.rskMsHeshbon, K.rskKodRofe, I.IndShem, R.rsrShem
FROM	dbo.T05rvKotrot K WITH (NOLOCK) 
			LEFT JOIN dbo.T05rvShurot S WITH (NOLOCK) ON S.rsdMsHazmana = K.rskMsHazmana
			LEFT JOIN [dbo].[T01IndHesbon] I WITH (NOLOCK) ON I.IndMsHeshbon = K.rskMsHeshbon
			LEFT JOIN [dbo].[T05Rofim] R WITH (NOLOCK) ON R.rsrCounter = K.rskKodRofe
GO
--SELECT * FROM dbo.vwMetupalDox ORDER BY rskMsHazmana DESC
--GO
--SELECT * FROM dbo.vwMetupalDox WHERE rskMsMetupal = 167843 ORDER BY rskMsHazmana DESC   
--GO
--SELECT * FROM dbo.vwMetupalDox WHERE rskMeupal LIKE 'משה כהן' ORDER BY rskMsHazmana DESC   
--GO

CREATE FUNCTION [dbo].[fnF05ListLakohotByRof] (@numRofe int)
RETURNS TABLE AS RETURN
	SELECT dbo.vwF05ListLakohot.*
	FROM dbo.vwF05ListLakohot 
	WHERE IndMsHeshbon IN (	SELECT [kshMsHeshbon] 
							FROM [dbo].[T05RofimLakoah] WITH (NOLOCK)
							WHERE [kshMsRofe] = @numRofe)
GO
--SELECT * FROM [dbo].[fnF05ListLakohotByRof](NULL)
------drop view dbo.vwF05ListLakohotActive
------CREATE VIEW dbo.vwF05ListLakohotActive
------AS
------SELECT dbo.vwF05ListLakohot.*
------FROM dbo.vwF05ListLakohot
------WHERE [IndMugbal] = 0 AND ([IndTarichSgira] IS NULL OR [IndTarichSgira] > GETDATE())
------GO
------select * from dbo.vwF05ListLakohotActive order by IndMsHeshbon
------select * from dbo.vwF05ListLakohot order by IndMsHeshbon

--A nice TVF for T09Klali
CREATE FUNCTION [dbo].[fnGetKlaliBySug] (@sugKlali nvarchar(3))
RETURNS TABLE AS RETURN
	SELECT klTable, klKod, klTeur
	FROM dbo.T09Klali WITH (NOLOCK)
	WHERE klTable = @sugKlali
GO
--examples from real cbos in app:
--for title:
--SELECT klTeur, klKod, klTable FROM [dbo].[fnGetKlaliBySug](N'ttl') ORDER BY klKod
--for cities:
--SELECT klTeur FROM [dbo].[fnGetKlaliBySug](N'cit') ORDER BY klTeur
--for matkin:
--SELECT klTable, klKod, klTeur FROM [dbo].[fnGetKlaliBySug](N'מתק')
--metal:
--SELECT klKod, klTeur FROM [dbo].[fnGetKlaliBySug](N'Mtl') ORDER BY klTeur
--eml:
--SELECT klKod, klTeur FROM [dbo].[fnGetKlaliBySug](N'eml') ORDER BY klTeur
GO

CREATE VIEW dbo.vwEzorim
AS
SELECT [KodEzor], [TeurEzor] 
FROM T09ezorim WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwEzorim ORDER BY [KodEzor]; 

CREATE VIEW dbo.vwKvuzot 
AS
SELECT [KvuMsKvuza], [KvSugKvuza], [KvuTeurKvuza] 
FROM T01Kvuzot WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwKvuzot ORDER BY [KvuMsKvuza]

CREATE VIEW dbo.vwQKesherMore 
AS
SELECT [ksrShem], [ksrTafkid], [ksrPelefon], [ksrLakoah], [ksrSugLakoah], [ksrCounter]
FROM dbo.T09Kesher WITH (NOLOCK)
WHERE [ksrSugLakoah] = N'ח'
GO
--SELECT * FROM dbo.vwQKesherMore WHERE [ksrLakoah] = 1001
--= [IndMsHeshbon]

CREATE VIEW dbo.vwIfunHeshAll
AS
SELECT [ifhRama], [ifhKod], [ifhTeur] 
FROM T01IfunHes WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwIfunHeshAll ORDER BY [ifhKod]
--SELECT * FROM dbo.vwIfunHeshAll WHERE [ifhRama] = '1' ORDER BY [ifhKod]

CREATE VIEW dbo.CboIsuk
AS
SELECT [isKod], [isTeur]
FROM dbo.T09Isuk WITH (NOLOCK)
GO
--SELECT * FROM dbo.CboIsuk ORDER BY [isKod]; 

CREATE VIEW dbo.vwMatbeot
AS
SELECT [CrnKodMatbea], [CrnNameMatbea] 
FROM dbo.T09Matbeot WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwMatbeot ORDER BY CrnKodMatbea

CREATE VIEW dbo.vwMehironimCbo
AS
SELECT [temMsMehiron], [temTeurMehironYhudi] 
FROM T03TeurMehiron WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwMehironimCbo ORDER BY temMsMehiron

CREATE VIEW dbo.vwAshrayCbo
AS
SELECT [ashKod], [ashTeur] 
FROM T01Ashray WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwAshrayCbo ORDER BY [ashKod]

CREATE VIEW dbo.vwPopUpCbo
AS
SELECT ppID, ppMsg 
FROM T09PopUpMsg WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwPopUpCbo ORDER BY ppID

CREATE VIEW dbo.vwBanksCbo
AS
SELECT bnkKod, bnkShem
FROM T01Bankim WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwBanksCbo ORDER BY bnkKod

--find new [dbo].[T01IndHesbon].[IndMsHeshbon] by [IndMsKvuza]
/*
איך מוצאים מספר חדש לחשבון:
לפי newAdd
שהיא הקבוצה שנשלחה,
מוצאים את המאקס מאינ-חשבון
ptqDlookup("MAX([IndMsHeshbon])", "dbo.T01IndHesbon", "IndMsKvuza = '" & newAdd & cnstGeresh
אם הוא קיים - מוסיפים לו אחד
אם לא
מוצאים את הממספר של הקבוצה מטבלת הקבוצות
KvuMeMispar from T01Kvuzot where KvuMsKvuza = '" & newAdd
אם עדיין נל אז הוא יהיה שווה לאחד
עושים לופ
כל עוד קיים באינד-חשבון חשבון במספר הזה - מעלים באחד ושוב בודקים
הראשון שפוגשים שאינו קיים - זה יהיה הוא
*/

CREATE FUNCTION [sps].[fnFindNewIndHeshNum] (@kvuNum nvarchar(3))
RETURNS int
AS BEGIN
	DECLARE @newIndHeshNum int, @tempNum int, @i int, @limit int;

	IF LEN(ISNULL(@kvuNum, '')) = 0
		RETURN NULL;

	SELECT @tempNum = MAX([IndMsHeshbon]) FROM dbo.T01IndHesbon WHERE IndMsKvuza = @kvuNum;
	IF NOT (@tempNum IS NULL)
		SET @tempNum = TRY_CONVERT(int, @tempNum + 1);
	ELSE		
		SELECT @tempNum = KvuMeMispar FROM dbo.T01Kvuzot where KvuMsKvuza = @kvuNum;			
		
	IF ISNULL(@tempNum, 0) = 0
		SET @tempNum = 1;

	SET @i = 1;
	SET @limit = 51;
	WHILE (@i < @limit)
		BEGIN			
			IF NOT EXISTS(SELECT * FROM dbo.T01IndHesbon WHERE IndMsHeshbon = @tempNum)
				BREAK; --this is the number we were looking for.
			ELSE
				BEGIN
					IF @i = (@limit - 1)
						BEGIN
							SET @tempNum = NULL;
							BREAK;
						END
					ELSE
						BEGIN
							SET @i = @i + 1;
							SET @tempNum = TRY_CONVERT(int, @tempNum + 1);
							IF @tempNum IS NULL
								BREAK;
						END
				END
		END;

		RETURN @tempNum;
END
GO
SELECT [sps].[fnFindNewIndHeshNum]('9') AS newIndHeshNum
GO
--nisui:
--INSERT INTO dbo.T01IndHesbon(IndMsHeshbon, IndShem, IndMsKvuza) VALUES (999, N'ניסוי נעם', N'9');
--GO
--DELETE FROM dbo.T01IndHesbon WHERE IndMsHeshbon = 999
--GO

CREATE VIEW dbo.vwShlavsWthInterpretIfyun
AS
SELECT	Sh.rslcounterShlav, Sh.rslKodShlav, Sh.rslTeurShlav, Sh.rslKodOved, Ov.ShemOved, Sh.rslYemeyAvoda, Sh.rslEfyun, 
		CASE	WHEN Sh.[rslEfyun] IS NULL THEN NULL
				WHEN Sh.[rslEfyun] = 0 THEN N'עבודה'
				WHEN Sh.[rslEfyun] = 1 THEN N'מדידה'
				WHEN Sh.[rslEfyun] = 2 THEN N'גמר'
				ELSE NULL END 
		AS 'teurIfyun'		
FROM	dbo.T05Shlavim Sh WITH (NOLOCK) LEFT JOIN dbo.T09Ovdim Ov WITH (NOLOCK) ON Sh.rslKodOved = Ov.MsOved;
GO
--SELECT * FROM dbo.vwShlavsWthInterpretIfyun
--SELECT rslKodShlav, rslTeurShlav, teurIfyun FROM dbo.vwShlavsWthInterpretIfyun
--GO

CREATE PROC [sps].[usp_AddOrEditItem]
	(@thisIsNewRecord bit, @orininalMakat nvarchar(24), @katMisparParit nvarchar(24), @katTeurParit nvarchar(120), @katTeurLOazi nvarchar(120), @katMehir money,
	 @katSivug nvarchar(1), @katIfun1 varchar(3), @katKodShlav nvarchar(4), @katWorkDays smallint, @katHeara nvarchar(MAX),
	 @katPrintBarcode bit, @katAllowMinus bit, @KatKamutMishtah int, @katNotActive int)
AS
BEGIN
	DECLARE @shlav varchar(60), @RetVal int, @RetErrNum int, @RetErrMsg nvarchar(4000);
	DECLARE @tempIntMakat int, @makeNewMakatMyself bit = 0, @finalMakat nvarchar(24);
	DECLARE @theRealOrigianlMakat nvarchar(24);

	SET XACT_ABORT, NOCOUNT ON;
	SELECT @RetVal = (-2), @RetErrNum = NULL, @RetErrMsg = NULL;

	SET @shlav = 'check arguments';
	IF @thisIsNewRecord IS NULL
		BEGIN
			SET @RetErrNum = 666;
			SET @RetErrMsg = N'לא נמסר לשרת אם זהו פריט חדש או קיים.';
			SELECT CONVERT(nvarchar(24), NULL) AS nothingHere;
			SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
			RETURN;
		END;
	IF @thisIsNewRecord = 0 AND LEN(ISNULL(@katMisparParit, '')) = 0
		BEGIN
			SET @RetErrNum = 666;
			SET @RetErrMsg = N'לא נשלח מספר הפריט לעדכון.';
			SELECT CONVERT(nvarchar(24), NULL) AS nothingHere;
			SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
			RETURN;
		END;
	IF @thisIsNewRecord = 0
		BEGIN
			SET @theRealOrigianlMakat = ISNULL(@orininalMakat, @katMisparParit);
			IF NOT EXISTS(SELECT * FROM [dbo].[T02katParitim] WITH (NOLOCK) WHERE [katMisparParit] = @theRealOrigianlMakat)
				BEGIN
					SET @RetErrNum = 666;
					SET @RetErrMsg = N'מאז התחלת לערוך את הפריט, משתמש אחר מחק אותו או שינה את מספרו.' + ' (' + @theRealOrigianlMakat + ')'
					SELECT CONVERT(nvarchar(24), NULL) AS nothingHere;
					SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
					RETURN;
				END
		END;
	IF @thisIsNewRecord = 1
		IF @katMisparParit IS NOT NULL
			IF EXISTS(SELECT * FROM [dbo].[T02katParitim] WITH (NOLOCK) WHERE [katMisparParit] = @katMisparParit)
				SET @makeNewMakatMyself = 1;
		ELSE
			SET @makeNewMakatMyself = 1;

	BEGIN TRY
		SET @shlav = 'determine final makat';	
		IF @thisIsNewRecord = 1 AND @makeNewMakatMyself = 1
			BEGIN
				SELECT @tempIntMakat = [sps].[fnFindNewNumber](N'prt');
				IF @tempIntMakat IS NULL
					BEGIN
						SET @RetErrNum = 666;
						SET @RetErrMsg = N'המערכת לא הצליחה למצוא מספר חדש לפריט.';
						SELECT CONVERT(nvarchar(24), NULL) AS nothingHere;
						SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
						RETURN;
					END;
				ELSE
					BEGIN
						SELECT @finalMakat = TRY_CONVERT(nvarchar(24), @tempIntMakat)
						IF @finalMakat IS NULL
							BEGIN
								SET @RetErrNum = 666;
								SET @RetErrMsg = N'המערכת לא הצליחה למצוא מספר חדש לפריט.';
								SELECT CONVERT(nvarchar(24), NULL) AS nothingHere;
								SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
								RETURN;
							END;
					END
			END;
		ELSE
			SET @finalMakat = @katMisparParit;

		BEGIN TRAN;
			IF @thisIsNewRecord = 1
				BEGIN
					SET @shlav = 'insert new makat';
					INSERT INTO [dbo].[T02katParitim] (katMisparParit, katTeurParit, katTeurLOazi, katMehir, 
								katSivug, katIfun1, katKodShlav, katWorkDays, katHeara, katPrintBarcode, katAllowMinus, KatKamutMishtah, katNotActive)
						VALUES (@finalMakat, @katTeurParit, @katTeurLOazi, @katMehir, @katSivug, @katIfun1, @katKodShlav,
								@katWorkDays, @katHeara, ISNULL(@katPrintBarcode, 0), ISNULL(@katAllowMinus, 0), @KatKamutMishtah, ISNULL(@katNotActive, 0));
					SET @shlav = 'chack rechesh table';
					IF NOT EXISTS(SELECT * FROM dbo.T02katRechesh WHERE karMisparParit = @finalMakat)
						INSERT INTO dbo.T02katRechesh (karMisparParit) VALUES (@finalMakat);
					SET @shlav = 'update Sugim table';
					IF ISNUMERIC(@finalMakat) = 1 AND (TRY_CONVERT(int, @finalMakat) IS NOT NULL)
						UPDATE [dbo].[T02Sugim] SET [sgmLast] = TRY_CONVERT(int, @finalMakat)
							WHERE [sgmSugMismach] = N'prt';
				END
			ELSE
				BEGIN
					SET @shlav = 'update existing makat';
					--SET @theRealOrigianlMakat = ISNULL(@orininalMakat, @katMisparParit); --Done earlier.
					UPDATE [dbo].[T02katParitim]
						SET katMisparParit = @katMisparParit, katTeurParit = @katTeurParit, katTeurLOazi = @katTeurLOazi,
							katMehir = @katMehir, katSivug = @katSivug, katIfun1 = @katIfun1, katKodShlav = @katKodShlav,
							katWorkDays = @katWorkDays, katHeara = @katHeara, katPrintBarcode = ISNULL(@katPrintBarcode, 0),
							katAllowMinus = ISNULL(@katAllowMinus, 0), KatKamutMishtah = @KatKamutMishtah, katNotActive = ISNULL(@katNotActive, 0)
						WHERE katMisparParit = @theRealOrigianlMakat;
					SET @shlav = 'chack rechesh table';
					IF NOT EXISTS(SELECT * FROM dbo.T02katRechesh WHERE karMisparParit = @katMisparParit)
						INSERT INTO dbo.T02katRechesh (karMisparParit) VALUES (@katMisparParit);
				END
			SET @shlav='return and select';	
			SET @RetVal = 1;
			SELECT CASE WHEN @thisIsNewRecord = 1 THEN @finalMakat ELSE @katMisparParit END AS 'returnedMakat';
			SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
		SET @shlav='commit transaction';
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		SET @RetErrNum = ERROR_NUMBER();
		SET @RetErrMsg = 'SQL Server - Database: ' + DB_NAME() + ' - Error in procedure ' + OBJECT_NAME(@@PROCID) + ' in shlav: ' + @shlav + '. Description: ' + ERROR_MESSAGE();		
		SET @RetVal = (-4);
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
		INSERT INTO [dbo].[ezrErrorLog]([mkFormName], [mkDescription], [mkNotes])
			VALUES (DB_NAME() + '.' + OBJECT_NAME(@@PROCID), 'Error ' + CONVERT(nvarchar(25), ERROR_NUMBER()), ERROR_MESSAGE());
		SELECT CONVERT(nvarchar(24), NULL) AS nothingHere;
		SELECT @RetVal AS 'retVal', @RetErrNum AS 'retErrNum', @RetErrMsg AS retErrMsg;
	END CATCH
END
GO
--EXEC [sps].[usp_AddOrEditItem] 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
--GO

CREATE VIEW dbo.vwKotNotesForBShenScr
AS
SELECT hrAsm, hrSug, hrDate, hrTime, hrCounter, hrNotes 
FROM dbo.T02KotNotes WITH (NOLOCK)
WHERE hrSug = N'הל'
GO
--SELECT * FROM dbo.vwKotNotesForBShenScr WHERE hrAsm = 4561 ORDER BY hrDate DESC, hrTime DESC, hrCounter
--GO

--get bunch of haadafot and other stuff for hazmana-screen:

CREATE TABLE dbo.ezrForHaadafotShen
(kod nvarchar(6) NOT NULL PRIMARY KEY)
GO
--SELECT * FROM dbo.ezrForHaadafotShen
INSERT INTO dbo.ezrForHaadafotShen (kod)
	SELECT 'הלש009'
	UNION SELECT 'הלש092'
	UNION SELECT 'הלש012'
	UNION SELECT 'הלש021'
	UNION SELECT 'הלש091'
	UNION SELECT 'הלש028'
	UNION SELECT 'הלש029'
	UNION SELECT 'הלש056'
	UNION SELECT 'הלש068'
	UNION SELECT 'הלש099'
	UNION SELECT 'בשכ025'
	UNION SELECT 'הלש095'
	UNION SELECT 'הלש008'
	UNION SELECT 'הלש020'
	UNION SELECT 'הלש026'
	UNION SELECT 'בשכ025'
	UNION SELECT 'הלש098'
	UNION SELECT 'הלש040'
	UNION SELECT 'הלש077'
GO
INSERT INTO dbo.ezrForHaadafotShen (kod)
	SELECT 'בשכ002'
	UNION SELECT 'בשכ003'
	UNION SELECT 'הלש022'
GO
--for child:
INSERT INTO dbo.ezrForHaadafotShen (kod)
	SELECT 'הלש003'
	UNION SELECT '001prt'
	UNION SELECT 'הלש032'
	UNION SELECT 'הלש035'
	UNION SELECT 'הלש065'
	UNION SELECT 'הלש083'
	UNION SELECT 'בשכ089'
	UNION SELECT 'הלש037'
GO
--more:
INSERT INTO dbo.ezrForHaadafotShen (kod)
	SELECT 'הלש050'
	UNION SELECT 'בשכ044'
	UNION SELECT 'הלש018'
	UNION SELECT 'הלש086'
	UNION SELECT 'הל004'
	UNION SELECT 'בשכ022'
	UNION SELECT 'בשכ011'
	UNION SELECT 'בשכ043'
	UNION SELECT 'בשכ015'
	UNION SELECT 'הלש093'
GO
--more:
INSERT INTO dbo.ezrForHaadafotShen (kod) SELECT 'בשכ012';
INSERT INTO dbo.ezrForHaadafotShen (kod) SELECT 'בשכ004';
INSERT INTO dbo.ezrForHaadafotShen (kod) SELECT 'בשכ086';
INSERT INTO dbo.ezrForHaadafotShen (kod) SELECT 'בשכ048';
GO

CREATE VIEW dbo.vwHaadafaBunchShen
AS
SELECT H.[hdSugReshuma], H.[hdYesNo], H.[hdNumber]
FROM [dbo].[T10Haadafot] H WITH (NOLOCK) INNER JOIN dbo.ezrForHaadafotShen E WITH (NOLOCK) ON E.kod = H.hdSugReshuma
GO
--SELECT * FROM dbo.vwHaadafaBunchShen ORDER BY hdSugReshuma
--GO

CREATE VIEW dbo.vwQItemOnlyIfyColor
AS
SELECT	PRT.katMisparParit, PRT.katTeurParit, PRT.katNotActive, PRT.katIfun1, CLR.itsColor, PRT.katSivug
FROM	dbo.T02katParitim PRT WITH (NOLOCK) LEFT JOIN dbo.vwColorByItm1Ifun CLR ON CLR.ifpkod = PRT.katIfun1
WHERE	PRT.katNotActive = 0
GO
--SELECT * FROM dbo.vwQItemOnlyIfyColor ORDER BY katMisparParit
--GO

--Shonim for Haz Shen:
CREATE VIEW dbo.vwQ05Shonim
AS
SELECT shnSugMismach, shnMsMismach, shnShem, shnKtovet, shnIr, ShnMikud, shnTelfon, ShnFax, ShnPelefon
FROM dbo.T01Shonim WITH (NOLOCK)
WHERE shnSugMismach = 'הל'
GO
--SELECT * FROM dbo.vwQ05Shonim

--making vw for OpenKotrotShenScreen from the beginning:
/*
it was:
CREATE VIEW [dbo].[vwOpenKotrotScreen]
AS
SELECT	[rskTarichKabala], [rskMsHazmana], [rskMsHeshbon], [rskKodRofe], [rskTotalSum], [rskIshur], [rskSagur], 
		[rskStatus], [rskMeupal], [rskMuzmanLetarich], [rskKodMazav], [rskAsm2], [rskKufsa], [rskMsOved], [rskZeva], [rskTik],
		CONVERT(int, [rv]) AS tmprv, [rskInHouse]
FROM	[dbo].[T05rvKotrot] WITH (NOLOCK)
WHERE	[rskSagur] = 0
GO
*/
--the new:
CREATE VIEW [dbo].[vwOpenKotrotScreenWhole]
AS
SELECT	K.rskTarichKabala, K.rskMsHazmana, CASE WHEN LEN(ISNULL(S.[shnShem], '')) = 0 THEN H.IndShem ELSE S.[shnShem] END AS shem,
		R.rsrShem, K.rskTotalSum, K.rskIshur AS origRskIshur, K.rskSagur, K.rskStatus, K.rskMsHeshbon, K.rskMeupal, 
		H.IndMsKvuza, K.rskMuzmanLetarich, H.IndMsHeshbon, K.rskKodMazav, Shl.rslTeurShlav, K.rskAsm2, K.rskKufsa,
		Ov.ShemOved, K.rskMsOved, K.rskZeva, K.rskTik, K.tmprv, K.rskInHouse		
FROM	[dbo].[vwOpenKotrotScreen] K
			LEFT JOIN dbo.T01IndHesbon H WITH (NOLOCK) ON H.IndMsHeshbon = K.rskMsHeshbon
			LEFT JOIN dbo.T05Rofim R WITH (NOLOCK) ON R.rsrCounter = K.rskKodRofe
			LEFT JOIN dbo.vwQ05Shonim S ON S.shnMsMismach = K.rskMsHazmana
			LEFT JOIN dbo.T05Shlavim Shl WITH (NOLOCK) ON Shl.rslKodShlav = K.rskStatus
			LEFT JOIN dbo.T09Ovdim Ov WITH (NOLOCK) ON Ov.MsOved = K.rskMsOved			
GO
--SELECT * FROM [dbo].[vwOpenKotrotScreenWhole] ORDER BY rskTarichKabala DESC, rskMsHazmana DESC
--GO

--for kombo ifyun-hesh with union no-ifyun:
CREATE VIEW dbo.vwIfyunHeshWith0No
AS
SELECT ifhRama, ifhKod, ifhTeur 
FROM dbo.vwIfunHeshAll 
WHERE [ifhRama] = '1'
UNION
SELECT CONVERT(varchar(1), '1') AS ifhRama, CONVERT(varchar(3), '0') AS ifhKod, N'***   ללא איפיון' AS ifhTeur
GO
--SELECT ifhKod, ifhTeur FROM dbo.vwIfyunHeshWith0No ORDER BY [ifhKod]
--GO

CREATE VIEW dbo.vwOvdimCbo
AS
SELECT [MsOved], [ShemOved]
FROM dbo.T09Ovdim WITH (NOLOCK)
GO
--SELECT * FROM dbo.vwOvdimCbo