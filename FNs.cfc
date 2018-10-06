<cfcomponent>
<cffunction name="QueryToStruct" access="public" returntype="any" output="false"
	hint="Converts an entire query or the given record to a struct. This might return a structure (single record) or an array of structures.">

	<!--- Define arguments. --->
	<cfargument name="Query" type="query" required="true" />
	<cfargument name="Row" type="numeric" required="false" default="0" />

	<cfscript>

		// Define the local scope.
		var LOCAL = StructNew();

		// Determine the indexes that we will need to loop over.
		// To do so, check to see if we are working with a given row,
		// or the whole record set.
		if (ARGUMENTS.Row){

			// We are only looping over one row.
			LOCAL.FromIndex = ARGUMENTS.Row;
			LOCAL.ToIndex = ARGUMENTS.Row;

		} else {

			// We are looping over the entire query.
			LOCAL.FromIndex = 1;
			LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;

		}

		// Get the list of columns as an array and the column count.
		LOCAL.Columns = ListToArray( ARGUMENTS.Query.ColumnList );
		LOCAL.ColumnCount = ArrayLen( LOCAL.Columns );

		// Create an array to keep all the objects.
		LOCAL.DataArray = ArrayNew( 1 );

		// Loop over the rows to create a structure for each row.
		for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){

			// Create a new structure for this row.
			ArrayAppend( LOCAL.DataArray, StructNew() );

			// Get the index of the current data array object.
			LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );

			// Loop over the columns to set the structure values.
			for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){

				// Get the column value.
				LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

				// Set column value into the structure.
				LOCAL.DataArray[ LOCAL.DataArrayIndex ][ lcase( LOCAL.ColumnName ) ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

			}

		}


		// At this point, we have an array of structure objects that
		// represent the rows in the query over the indexes that we
		// wanted to convert. If we did not want to convert a specific
		// record, return the array. If we wanted to convert a single
		// row, then return the just that STRUCTURE, not the array.
		if (ARGUMENTS.Row){

			// Return the first array item.
			return( LOCAL.DataArray[ 1 ] );

		} else {

			// Return the entire array.
			return( LOCAL.DataArray );

		}

	</cfscript>
</cffunction>
	<Cffunction name="die">
		<cfdump var="#arguments#" abort />
	</Cffunction>
	<cffunction name="QueryToArray" access="public" returntype="array" output="false"
	    hint="This turns a query into an array of structures.">
	
	    <!--- Define arguments. --->
	    <cfargument name="Data" type="query" required="yes" />
	
	    <cfscript>
	        // Define the local scope.
	        var LOCAL = StructNew();
	        // Get the column names as an array.
	        LOCAL.Columns = ListToArray( ARGUMENTS.Data.ColumnList );
	        // Create an array that will hold the query equivalent.
	        LOCAL.QueryArray = ArrayNew( 1 );
	        // Loop over the query.
	        for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
	            // Create a row structure.
	            LOCAL.Row = StructNew();
	            // Loop over the columns in this row.
	            for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
	                // Get a reference to the query column.
	                LOCAL.ColumnName = LOCAL.Columns[ lcase( LOCAL.ColumnIndex ) ];
	                // Store the query cell value into the struct by key.
	                LOCAL.Row[ lcase( LOCAL.ColumnName ) ] = ARGUMENTS.Data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
	            }
	            // Add the structure to the query array.
	            ArrayAppend( LOCAL.QueryArray, LOCAL.Row );
	        }
	        // Return the array equivalent.
	        return( LOCAL.QueryArray );
	    </cfscript>
	</cffunction>
</cfcomponent>