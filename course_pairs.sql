/* This query collects registration data for specified courses */

SELECT DISTINCT	
			fr.VersionKey AS VersionKeyRegistration,	
			vfspo.VersionKey AS VersionKeyStudentPlanOwner,	
			fr.TermKey,	
			dt.SourceKey AS TermSourceKey,	
			dt.Description AS Term,	
			instmode.Description AS InstructionMode,	
			dcn.SubjectSourceKey AS Subject,	
			dcn.CatalogNumberSourceKey AS CourseNumber,	
			dcn.ClassSectionSourceKey AS Section,	
			dcn.ClassNumberUniqueDescription,	
			dcn.ClassNumberSectionPaddedDescription AS TotalCourseDescription,	
			(SELECT ds.SourceKey FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS StudentID,	
			vfspo.EmployeeID,  vfspo.PlanCount, vfspo.AcademicPlan, vfspo.AcademicSubPlan,	
			df.UniqueDescription As Instructor,	
			fr.StudentAge,	
			(SELECT UniqueDescription FROM Final.DimAcademicLevel al WHERE fst.AcademicLevelKey = al.AcademicLevelKey) AS AcademicLevel,
			
			fst.FirstTermAtInstitutionCount AS FirstTermAtInstitutionIndicator,
			fst.FirstTermInProgramCount,
			fst.FirstTermInProgramIndicatorKey,
			dftipi.Code,
			dftipi.Description,
			dftipi.LongDescription,
			dftipi.RollupDescription,
			dftipi.ShortDescription,
			
			fst.CumulativeGPA,	
			(SELECT UniqueDescription FROM CustomFinal.DimFirstGeneration dfg WHERE fst.FirstGenerationKey = dfg.FirstGenerationKey) AS FirstGen,	
			(SELECT UniqueDescription FROM CustomFinal.DimVeteranAffiliated vet WHERE fst.VeteranAffiliatedKey = vet.VeteranAffiliatedKey) AS VeteranAff,	
				
			fst.HasTransferCumGPA,	
			dal.Description, daltk.FullTimePartTimeDescription, 	

			dv.Description AS VersionDescription,
			EnrolledClassCount, DropCount, fr.WithdrawCount, CreditsAttempted, CreditsEarned, dg.EarnCreditIndicator, dg.SuccessIndicator,	
			HasClassGrade, ClassGrade, dg.GradeKey, dg.SourceKey AS GradeLetter, dg.GradePoints, dg.GradeDescription, dg.GradeSubgroup, dg.GradeGroup, dg.GradingBasisDescription,	

			EnrollStatus, RegistrationAddDate, RegistrationDropDate, 
			dri.Description AS RepeatDescripton, dri.ShortDescription AS RepeatDescriptionShort, dri.SummaryIndicator AS RepeatSummaryIndicator

	FROM	Final.FactRegistration fr	

			JOIN	Final.DimTerm dt	
			ON		fr.Termkey = dt.TermKey	

			JOIN	Final.DimClassNumber dcn	
			ON		fr.ClassNumberKey = dcn.ClassNumberKey	

			JOIN	Final.FactStudentTerm fst	
			ON		fr.StudentKey = fst.StudentKey 	
			AND		fr.TermKey = fst.TermKey	
			AND		fr.VersionKey = fst.VersionKey	

			JOIN	Final.DimInstructionMode instmode	
			ON		fr.InstructionModeKey = instmode.InstructionModeKey	

			JOIN	Final.DimFaculty df	
			ON		fr.FacultyKey = df.FacultyKey	

			JOIN	Final.DimAcademicLevel dal	
			ON		fr.AcademicLevelKey = dal.AcademicLevelKey	

			JOIN	Final.DimAcademicLoadTuition daltk	
			ON		fr.AcademicLoadTuitionKey = daltk.AcademicLoadTuitionKey	

			JOIN	CustomFinal.ViewFactStudentPlanOwner vfspo	
			ON		fr.StudentKey = vfspo.StudentKey 	
			AND		fr.TermKey = vfspo.TermKey	
			AND		fr.VersionKey = vfspo.VersionKey	

			JOIN	Final.DimVersion dv	
			ON		vfspo.VersionKey = dv.VersionKey	

			JOIN 	CustomFinal.DimBSURepeatIndicator dri
			ON 		fr.BSURepeatIndicatorKey = dri.BSURepeatIndicatorKey

			JOIN	Final.DimGrade dg	
			ON		fr.GradeKey = dg.GradeKey

			JOIN	Final.DimFirstTermInProgramIndicator dftipi
			ON		fr.FirstTermInProgramIndicatorKey = dftipi.FirstTermInProgramIndicatorKey
					

	WHERE	dt.SourceKey in ('1159', '1163', '1169', '1173', '1179', '1183', '1189', '1193', '1199', '1203', '1209')	
	AND		dcn.ClassNumberUniqueDescription LIKE ('%BUSMGT%')	
	AND 	instmode.Description = 'Online'	
	AND     fr.VersionKey = 3 /*End of term snapshot*/	
	AND		dg.GradeDescription != 'No Grade'
