SELECT DISTINCT 

	TermKey, TermSourceKey, EmployeeID, dp.PlanUniqueDescription, dm.MajorDescription, fsp.FirstTermInMajorCount

FROM Final.FactStudentPlan fsp

JOIN Final.DimPlan dp
ON fsp.PlanKey = dp.PlanKey

JOIN Final.DimMajor dm
ON fsp.MajorKey = dm.MajorKey

WHERE PlanUniqueDescription LIKE '%MGMT-BBA%'
/*AND TermSourceKey NOT LIKE '%6' */
AND fsp.FirstTermInMajorCount = 1

ORDER BY EmployeeID, TermKey
