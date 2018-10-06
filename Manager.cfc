component extends="Object"{
	/**
		@hint I take a query row and convert it to a structure.
		@param size The number of bytes to generate the salt
	*/
	public struct function queryRowToStruct( required query qry, numeric fetch_row=1, boolean to_lower=false ) {
			/**
			 * Makes a row of a query into a structure.
			 *
			 * @param query 	 The query to work with.
			 * @param row 	 Row number to check. Defaults to row 1.
			 * @return Returns a structure.
			 * @author Nathan Dintenfass (nathan@changemedia.com)
			 * @version 1, December 11, 2001
			 */
			//by default, do this to the first row of the query
			var row = fetch_row;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(qry.columnList);
			//the struct to return
			var stReturn = structnew();

			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				if( to_lower ){
					stReturn[lcase(cols[ii])] = qry[cols[ii]][row];
				}else{
					stReturn[cols[ii]] = qry[cols[ii]][row];
				}

			}
			//return the struct
			return stReturn;
	}
	/**
	* Takes a query and transforms it into a struct, or a struct of arrays
	* @recordset The query to convert
	* @columns A comma-delimited list of columns to create in each of the structures (columns that are not defined in the query are created as empty strings)
	* @single Whether or not only a single column / row should be returned
	* @lower Whether or not to convert the query columns into lowercase
	* @map A closure to be called on every row.  The closure is passed: row, index, columns and must return row
	*/
	public struct function queryToStruct(
		required query recordset,
		string columns=arguments.recordset.columnList,
		boolean single=false,
		boolean lower=true,
		any map,
		any data=""
	) {
		var result = {};
		var row = {};
		var cnt = 0;
		var cols = listToArray( arguments.lower ? lCase( arguments.columns ) : arguments.columns );
		cnt = arrayLen( cols );
		// if map exists and it is a closure, call it for every row and column
		if( structKeyExists( arguments, "map") && isClosure( arguments.map ) ) {
			if( !arguments.single ) {
				// define each column as a struct key
				for( var i = 1; i <= cnt; i++ ) {
					result[cols[i]] = [];
				}
				// loop over the query
				for( var i = 1; i <= arguments.recordset.recordCount; i++ ){
					row = {}; // define a placeholder for the row
					// loop each of the columns, make sure it actually is a query column, if not set an empty string
					for( var c = 1; c <= cnt; c++ ) {
						row[cols[c]] = listFindNoCase( arguments.recordset.columnList, cols[c] ) ? arguments.recordset[cols[c]][i] : "";
					}
					// call the map function on the whole row
					row = arguments.map( row=row, index=i, columns=arguments.columns );
					// loop each of the columns again setting each value
					for( var c = 1; c <= cnt; c++ ) {
						result[arguments.lower ? lCase( cols[c] ) : cols[c]][i]= row[cols[c]];
					}
				}
			}
			else { // just loop over each column and reference the 1st record, calling the map for each column
				for( var i = 1; i <= cnt; i++ ) {
					result[cols[i]] = listFindNoCase( arguments.recordset.columnList, cols[i] ) ? arguments.recordset[cols[i]][1] : "";
				}
				// call the map function on the whole row
				result = arguments.map( row=result, index=i, columns=arguments.columns, data=arguments.data );
			}
		}
		else { // just loop over each record and column normally without extra processing
			if( !arguments.single ) { // loop over all the columns calling to toArray() method
				for( var i = 1; i <= cnt; i++ ) {
					// make sure the column exists
					if( listFindNoCase( arguments.recordset.columnList, cols[i] ) ) {
						result[cols[i]] = arguments.recordset[cols[i]].toArray();
					}
					else { // fake column, just define it as an array w/ empty values
						result[arguments.lower ? lCase(cols[i]) : cols[i]] = [];
						arraySet(result[cols[i]], 1, arguments.recordset.recordCount, "");
					}
				}
			}
			else { // just loop over each column and reference the 1st record
				for( var i = 1; i <= cnt; i++ ) {
					result[cols[i]] = listFindNoCase( arguments.recordset.columnList, cols[i] ) ? arguments.recordset[cols[i]][1] : "";
				}
			}
		}
		return result;
	}
	/**
	* Takes a query and transforms it into a an array of structs
	* @recordset The query to convert
	* @columns A comma-delimited list of columns to create in each of the structures (columns that are not defined in the query are created as empty strings)
	* @lower Whether or not to convert the query columns into lowercase
	* @map A closure to be called on every row.  The closure is passed: row, index, columns and must return row
	*/
	public array function queryToArray(
		required query recordset,
		string columns=arguments.recordset.columnList,
		boolean lower=true,
		any map,
		any data=""
	) {
		var result = [];
		var cnt = 0;
		var cols = listToArray( arguments.lower ? lCase( arguments.columns ) : arguments.columns );

		cnt = arrayLen( cols );
		// if map exists and it is a closure, call it for every row and column
		if( structKeyExists( arguments, "map") && isClosure( arguments.map ) ) {
			for( var i = 1; i <= arguments.recordset.recordCount; i++ ){
				result[i] = {};
				// build the initial row
				for( var c = 1; c <= cnt; c++ ) {
					result[i][cols[c]] = listFindNoCase( arguments.recordset.columnList, cols[c] ) ? arguments.recordset[cols[c]][i] : "";
				}
				// call the map function on the whole row
				result[i] = arguments.map( row=result[i], index=i, columns=arguments.columns, data=arguments.data );
			}
		}
		else { // just loop over each record and column normally without extra processing
			for( var i = 1; i <= arguments.recordset.recordCount; i++ ) {
				result[i] = {};
				// loop each of the columns, make sure it actually is a query column, if not set an empty string
				for( var c = 1; c <= cnt; c++ ) {
					result[i][cols[c]] = listFindNoCase( arguments.recordset.columnList, cols[c] ) ? arguments.recordset[cols[c]][i] : "";
				}
			}
		}
		return result;
	}
	/**
	 * Compares two lists and returns the elements that do not appear in both lists. Returns a list that contains the elementsrest between list1 and list2
	 *
	 * @param list1      First list to compare (Required)
	 * @param list2      Second list to compare (Required)
	 * @param delimiters      Delimiter for all lists.  Defualt is comma. (Optional)
	 * @return Returns a string.
	 * @author Ivan Rodriguez (wantez015@hotmail.com)
	 * @version 1, June 26, 2002
	 */
	public string function ListDiff( required string list1, required string list2 ) {
	  var delimiters    = ",";
	  var listReturn = "";
	  var position = 1;

	  // default list delimiter to a comma unless otherwise specified
	  if (arrayLen(arguments) gte 3){
	    delimiters    = arguments[3];
	  }

	  //checking list1
	  for(position = 1; position LTE ListLen(list1,delimiters); position = position + 1) {
	    value = ListGetAt(list1, position , delimiters );
	    if (ListFindNoCase(list2, value , delimiters ) EQ 0)
	      listReturn = ListAppend(listReturn, value , delimiters );
	    }

	    //checking list2
	    for(position = 1; position LTE ListLen(list2,delimiters); position = position + 1)    {
	      value = ListGetAt(list2, position , delimiters );
	      if (ListFindNoCase(list1, value , delimiters ) EQ 0)
	        listReturn = ListAppend(listReturn, value , delimiters );
	  }
	  return listReturn;
	}
	/**
		collectionToQuery
		http://cflib.org/udf/ArrayOfStructuresToQuery
	**/
	public query function collectionToQuery(theArray){
		var colNames = "";
		var theQuery = queryNew("");
		var i=0;
		var j=0;
		//if there's nothing in the array, return the empty query
		if(NOT arrayLen(theArray))
			return theQuery;
		//get the column names into an array =
		colNames = structKeyArray(theArray[1]);
		//build the query based on the colNames
		theQuery = queryNew(arrayToList(colNames));
		//add the right number of rows to the query
		queryAddRow(theQuery, arrayLen(theArray));
		//for each element in the array, loop through the columns, populating the query
		for(i=1; i LTE arrayLen(theArray); i=i+1){
			for(j=1; j LTE arrayLen(colNames); j=j+1){
				querySetCell(theQuery, colNames[j], theArray[i][colNames[j]], i);
			}
		}
		return theQuery;
	}
	/**
	 * Sorts an array of structures based on a key in the structures.
	 *
	 * @param aofS 	 Array of structures. (Required)
	 * @param key 	 Key to sort by. (Required)
	 * @param sortOrder 	 Order to sort by, asc or desc. (Optional)
	 * @param sortType 	 Text, textnocase, or numeric. (Optional)
	 * @param delim 	 Delimiter used for temporary data storage. Must not exist in data. Defaults to a period. (Optional)
	 * @return Returns a sorted array.
	 * @author Nathan Dintenfass (nathan@changemedia.com)
	 * @version 1, April 4, 2013
	 */
	function arrayOfStructsSort(aOfS,key){
		//by default we'll use an ascending sort
		var sortOrder = "asc";
		//by default, we'll use a textnocase sort
		var sortType = "textnocase";
		//by default, use ascii character 30 as the delim
		var delim = ".";
		//make an array to hold the sort stuff
		var sortArray = arraynew(1);
		//make an array to return
		var returnArray = arraynew(1);
		//grab the number of elements in the array (used in the loops)
		var count = arrayLen(aOfS);
		//make a variable to use in the loop
		var ii = 1;
		//if there is a 3rd argument, set the sortOrder
		if(arraylen(arguments) GT 2)
			sortOrder = arguments[3];
		//if there is a 4th argument, set the sortType
		if(arraylen(arguments) GT 3)
			sortType = arguments[4];
		//if there is a 5th argument, set the delim
		if(arraylen(arguments) GT 4)
			delim = arguments[5];
		//loop over the array of structs, building the sortArray
		for(ii = 1; ii lte count; ii = ii + 1)
			sortArray[ii] = aOfS[ii][key] & delim & ii;
		//now sort the array
		arraySort(sortArray,sortType,sortOrder);
		//now build the return array
		for(ii = 1; ii lte count; ii = ii + 1)
			returnArray[ii] = aOfS[listLast(sortArray[ii],delim)];
		//return the array
		return returnArray;
	}
	/**
	* Serialize data into a Base64-encoded JSON string
	*
	* @dataToSerialize The object to serialize
	*/
	public string function serializeData( required any dataToSerialize ) {
		//Serialize the data into a JSON string
		var serializedData = serializeJSON( arguments.dataToSerialize, true );
		var base64Data = toBase64( serializedData );//Convert to base64
		var urlEncodedData = urlEncodedFormat( base64Data );//URL Encode the data

		return urlEncodedData;
	}
	/**
	* De-serialize Base64-encoded JSON string back to data object
	*
	* @dataToDeserialize The string of encoded data to deserialize
	*/
	public any function deserializeData( required string dataToDeserialize ) {
		//Decode the URL encoded string
		try{
			var urlDecodedData = urlDecode( dataToDeserialize );
			var binaryData = toBinary( urlDecodedData );//Convert to Binary
			var stringData = toString( binaryData );//Convert to String
			var deserializedData = dataToDeserialize;

			if( isjson(stringData) ){
				deserializedData= deserializeJSON( stringData, false );//Deserialize the JSON string
			}

			return deserializedData;
		}catch(any e){
			if( isSimpleValue(dataToDeserialize)) return dataToDeserialize;

			return '';
		}
	}	
}