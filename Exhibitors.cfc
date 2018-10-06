<cfcomponent>
	<cffunction name="setFavExhibitor" access="public" output="no">
		<cfargument name="eventId" required="yes" />		
		<cfargument name="regid" required="yes" />		
		<cfargument name="exhibid" required="yes" />		
		<cfargument name="set" required="yes" />		
		<cfif set eq "yes">
			<cfquery name="q" dataSource="#request.dsn#">
				insert into dbo.app_fav_exhibitors (exhib_id, reg_id, event_id)
				values(
					<cfqueryparam value="#exhibid#" />,
					<cfqueryparam value="#regid#" />,
					<cfqueryparam value="#eventId#" />	
				)
			</cfquery>
		<Cfelse>
			<cfquery name="q" dataSource="#request.dsn#">
				delete from dbo.app_fav_exhibitors 
				where exhib_id = 
					<cfqueryparam value="#exhibid#" />
				and reg_id = 
					<cfqueryparam value="#regid#" />
				and event_id =
					<cfqueryparam value="#eventId#" />	
			</cfquery>
		</cfif>
		<Cfreturn  />
	</cffunction>


	<cffunction name="getExhibitors" access="public" output="no">
		<cfargument name="clientId" required="yes" />
		<cfargument name="eventId" required="yes" />		
		<cfargument name="regid" required="no" default="0" />		
		<cfquery name="q" dataSource="#request.dsn#">

			SELECT eb.booth_num as booth_number, E.Exhibitor,E.Exhib_ID,EE.Exhib_Status,E.create_date,EE.has_Lockout,EE.has_Format,EE.has_Login,EE.Contract_Status,EE.Total_Badges,EE.LoginSend_Date,EE.Booth_Selection_Notes,EE.logo_file, LEN(cast(EE.Description as varchar(1000))) AS Desc_Len,EE.event_exhib_id, LEN(cast(EE.Comments as varchar(1000))) AS Comment_Len, 
			(SELECT TOP 1 Email FROM Exhib_Contacts WHERE Exhib_ID = E.Exhib_ID) AS Contact_Email, 
			isNull( (select f.exhib_ID  from dbo.app_fav_exhibitors f where f.exhib_ID = e.exhib_id and f.reg_id = <cfqueryparam value="#regid#" />), 0 ) as favorite
			FROM Exhibitors E 
			INNER JOIN XR_Event_Exhibs EE ON E.Exhib_ID = EE.Exhib_ID 
			left join dbo.exhib_Booths eb on eb.exhib_id = e.exhib_id
			WHERE EE.Exhib_ID = EE.ExhibAs_ID AND EE.Event_ID = <cfqueryparam value="#eventId#" />  AND EE.Exhib_Status = 'Active' 
			and len( e.Exhibitor ) > 0
			ORDER BY E.Exhibitor
		</cfquery>
		<Cfreturn q />
	</cffunction>
	<cffunction name="getMyExhibitors" access="public" output="no">
		<cfargument name="eventId" required="yes" />		
		<cfargument name="regid" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#">
			SELECT distinct E.Exhib_ID, eb.booth_num as booth_number, E.Exhibitor 
			FROM Exhibitors E INNER JOIN XR_Event_Exhibs EE ON E.Exhib_ID = EE.Exhib_ID 
			inner join dbo.app_fav_exhibitors as f on f.exhib_ID = e.exhib_id
			left join dbo.exhib_Booths eb on eb.exhib_id = e.exhib_id

			WHERE  f.reg_id = <cfqueryparam value="#regid#" /> 
			ORDER BY E.Exhibitor



		</cfquery>
		<Cfreturn q />
	</cffunction>


	<cffunction name="getExhibitor" access="public" output="no">
		<cfargument name="clientId" required="yes" />
		<cfargument name="eventId" required="yes" />		
		<cfargument name="exhibId" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#">
			select top 1 * from dbo.Exhibitors
			where exhib_id = <cfqueryparam value="#exhibId#" />
			order by exhibitor asc
		</cfquery>
		<Cfreturn q />
	</cffunction>

</cfcomponent>