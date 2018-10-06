<cfcomponent>
	<cffunction name="setFavFile" access="public" output="no">
		<cfargument name="eventId" required="yes" />		
		<cfargument name="regid" required="yes" />		
		<cfargument name="fileId" required="yes" />		
		<cfargument name="set" required="yes" />		
		<cfif set eq "yes">
			<cfquery name="q" dataSource="#request.dsn#">
				insert into dbo.app_fav_files (file_id, reg_id, event_id)
				values(
					<cfqueryparam value="#fileId#" />,
					<cfqueryparam value="#regid#" />,
					<cfqueryparam value="#eventId#" />	
				)
			</cfquery>
		<Cfelse>
			<cfquery name="q" dataSource="#request.dsn#">
				delete from dbo.app_fav_files 
				where file_id = 
					<cfqueryparam value="#fileId#" />
				and reg_id = 
					<cfqueryparam value="#regid#" />
				and event_id =
					<cfqueryparam value="#eventId#" />	
			</cfquery>
		</cfif>
		<Cfreturn  />
	</cffunction>

	<cffunction name="getMyFiles" access="public" output="no">
		<cfargument name="domain" required="yes" />	
		<cfargument name="prefix" required="yes" />	
		<cfargument name="eventId" required="yes" />		
		<cfargument name="regid" required="yes" />		
		<cfquery name="q" dataSource="#request.dsn#">
			select 'https://#domain#.eventready.com/files/#prefix#/' + file_name as file_path, file_name as description, file_type, *
			FROM event_files E 
			inner join dbo.app_fav_files as f on f.file_id = e.file_id
			WHERE  f.reg_id = <cfqueryparam value="#regid#" /> 
		</cfquery>
		<Cfreturn q />
	</cffunction>

	<cffunction name="getFiles" access="public" output="no">
		<cfargument name="domain" required="yes" />	
		<cfargument name="prefix" required="yes" />	
		<cfargument name="clientId" required="yes" />
		<cfargument name="eventId" required="yes" />	
		<cfargument name="regid" required="yes" />		

		<cfquery name="q" dataSource="#request.dsn#">
			select 'https://#domain#.eventready.com/files/#prefix#/' + file_name as file_path, file_name as description, file_type, *,
			isNull( (select f.file_id from dbo.app_fav_files f where f.file_id = e.file_id and f.reg_id = <cfqueryparam value="#regid#" />), 0 ) as favorite
			from event_files as e			
			where event_id = <cfqueryparam value="#eventId#" /> 
			order by file_name
		</cfquery>
		<Cfreturn q />
	</cffunction>
</cfcomponent>