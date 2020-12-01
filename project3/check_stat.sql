select *
FROM `nih-sra-datastore.sra_tax_analysis_tool.tax_analysis` as T
where T. rank IS NOT NULL
and T.total_count >10000
and T.self_count > 10000
and T.acc IN
(
'ERR3209766',
'ERR3209768',
'ERR3209849',
'ERR3209854',
'ERR3209966'

)
order by T.acc, T.total_count DESC, T.self_count DESC
