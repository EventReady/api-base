<cfcomponent>
	<cffunction name="getWhatsOn" access="public" output="no">
		<cfargument name="locationId" required="yes" />
		<cfquery name="q" dataSource="#request.dsn#">
			SELECT S.Session_Name,S.Session_Status,S.Start_Date,S.Start_Time,S.End_Time,S.Session_ID,S.Seats,S.Track_ID,T.Track_Name
			FROM Loc_Sessions S INNER JOIN Loc_Tracks T
				ON S.Track_ID = T.Track_ID
			WHERE S.Location_ID = <cfqueryparam value="#locationId#" />
			AND	CONVERT(VARCHAR(10), start_date, 101) = '#dateformat( now(), "mm/dd/yyyy" )#'
			and datepart( hh, CONVERT(VARCHAR(8), start_time, 108) ) > #(( hour( now() ) - 2 ) + 3 )#
			and datepart( hh, CONVERT(VARCHAR(8), start_time, 108) ) < #(( hour( now() ) + 3 ) + 3 )#			
			ORDER BY Start_Date,Start_Time,Session_Name, track_name
		</cfquery>
		<Cfreturn q />
	</cffunction>
</cfcomponent>

