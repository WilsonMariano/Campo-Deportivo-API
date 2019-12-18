<?php

require_once __DIR__ . '/../_FxEntidades.php';

class GenericApi {

    public static function GetAll($request, $response, $args) {

		//Traigo  todos los items
		$apiParams = $request->getQueryParams();
		$listado= FxEntidades::GetAll($apiParams["t"]);
		
		if($listado)
			return $response->withJson($listado, 200); 		
		else   
			return $response->withJson(false, 400);
    }
    
    public static function GetOne($request, $response, $args) { 

		$apiParams = $request->getQueryParams();
		$id = json_decode($args['id']);
		
		$obj= FxEntidades::GetOne($id,$apiParams["t"]);
		
		if($obj)
			return $response->withJson($obj, 200); 
		else
			return $response->withJson(false, 400);  
	} 

	public static function Insert($request, $response, $args) {

		//Datos recibidos por QueryString y Body
		$apiParamsQS = $request->getQueryParams();
		$apiParamsBody = $request->getParsedBody();	
		
		// Obtengo instancia de clase correspondiente.
		$objEntidad = FxEntidades::GetObjEntidad($apiParamsQS['t'], $apiParamsBody);

		if($objEntidad)
			if(FxEntidades::InsertOne($objEntidad))
				return $response->withJson(true, 200); 
			else
				return $response->withJson(false, 500);  			
		else
			return $response->withJson(false, 400);  			
	}

	public static function UpdateOne($request, $response, $args) {
		
		//Datos recibidos por QueryString y Body
		$apiParamsQS = $request->getQueryParams();
		$apiParamsBody = $request->getParsedBody();	

		// Obtengo instancia de clase correspondiente.
		$objEntidad = FxEntidades::GetObjEntidad($apiParamsQS['t'], $apiParamsBody);

		if($objEntidad)
			if(FxEntidades::UpdateOne($objEntidad))
				return $response->withJson(true, 200); 
			else
				return $response->withJson(false, 500);  			
		else
			return $response->withJson(false, 400);  			
					
	}

	
}