component extends="base.Manager"{
	variables.fn = new base.FNs();
	variables.queryOptions =  { datasource : request.dsn };
	/*
	**-------------------------------------------------------------------------------------
	** METHOD NAME - setPlayerId
	**-------------------------------------------------------------------------------------
	*/
	public boolean function setPlayerId(
		reg_id, client_id, event_id, player_id, data
	){
		var hasPlayerId = checkPlayerId( reg_id, client_id, event_id );
		if( arrayLen( hasPlayerId ) == 0 ){
			var sql = "
				INSERT INTO dbo.app_onesignal_ids(
					reg_id, player_id, client_id, event_id, data, create_date
				)
				VALUES(
					:reg_id, :player_id, :client_id, :event_id, :data, getDate()
				)
			";
			queryExecute(sql, {
				reg_id : reg_id, player_id : player_id, client_id : client_id, event_id : event_id , data : data		
			}, queryOptions);
		}

		return true;
	}
	/*
	**-------------------------------------------------------------------------------------
	** METHOD NAME - checkPlayerId
	**-------------------------------------------------------------------------------------
	*/
	public array function checkPlayerId( reg_id, client_id, event_id ){
		var sql = "
			select 1 from dbo.app_onesignal_ids
			where reg_id = :reg_id 
			and client_id = :client_id
			and event_id = :event_id	
		";
		var ret = queryExecute(sql, {
			reg_id : reg_id, client_id : client_id, event_id : event_id
		}, { datasource : request.dsn });
		return fn.queryToArray( ret );
	}	
}