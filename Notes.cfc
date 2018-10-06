<cfcomponent>
	<Cffunction name="deleteNote" access="public" output="no">
		<cfargument name="regid" />
		<cfargument name="noteid" />
		
		<cfquery name="q" dataSource="#request.dsn#">
			delete from app_notes 
			where reg_id = <cfqueryparam value="#regId#" /> and id = <cfqueryparam value="#noteId#" />
		</cfquery>
	</Cffunction>

	<Cffunction name="saveNote" access="public" output="no">
		<cfargument name="regid" />
		<cfargument name="note" />
		<cfargument name="noteid" />
		
		<cfquery name="q" dataSource="#request.dsn#">
			update app_notes 
			set note = <cfqueryparam value="#note#" />
			where reg_id = <cfqueryparam value="#regId#" /> and id = <cfqueryparam value="#noteId#" />
		</cfquery>
	</Cffunction>

	<Cffunction name="addNote" access="public" output="no">
		<cfargument name="regid" />
		<cfargument name="note" />
		<cfargument name="noteType" />
		
		<cfquery name="q" dataSource="#request.dsn#">
			insert into app_notes (
				reg_id, note, note_type, created_date
			)
			values(
				<cfqueryparam value="#regId#" />,
				<cfqueryparam value="#note#" />,
				<cfqueryparam value="#noteType#" />,
				getDate()
			)
		</cfquery>
	</Cffunction>
	<Cffunction name="getNotes" access="public" output="no">
		<cfargument name="regid" />
		
		<cfquery name="q" dataSource="#request.dsn#">
			select * from dbo.app_notes where reg_id = <cfqueryparam value="#regid#" />
			order by note_type asc
		</cfquery>
		<Cfreturn q />
	</Cffunction>

	<Cffunction name="sendNotes" access="public" output="no">
		<cfargument name="regid" />		
		<cfquery name="q" dataSource="#request.dsn#">
			select * from dbo.app_notes where reg_id = <cfqueryparam value="#regid#" />
			order by note_type asc
		</cfquery>
		<Cfreturn q />
	</Cffunction>
</cfcomponent>
