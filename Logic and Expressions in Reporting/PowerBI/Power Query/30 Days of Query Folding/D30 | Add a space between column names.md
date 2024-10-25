
D30 : The column names are typed using the camel case for column name, so the query here will be separating the names for each column, based on Capital Letters.

    let
    	Source = Sql.Databases("ASALAMA\MSSQLSERVER01"),
    	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
    	dbo_DimPromotion = AdventureWorksDW2017{[Schema = "dbo", Item = "DimPromotion"]}[Data],
    	#"Add Spaces" = Table.TransformColumnNames(
    		dbo_DimPromotion, 
    		each Text.Combine(Splitter.SplitTextByCharacterTransition({"a".."z"}, {"A".."Z"})(_), " ")
    	)
    in
    	#"Add Spaces"
