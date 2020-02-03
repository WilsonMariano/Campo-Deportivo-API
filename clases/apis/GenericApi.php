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
			if(is_numeric(FxEntidades::InsertOne($objEntidad)))
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

	public static function GetPagedWithOptionalFilter($request, $response, $args) {

		$apiParams = $request->getQueryParams();
		
		$e  = $apiParams['entity'];
		$c1 = $apiParams['col1'] ?? null; 
		$t1 = $apiParams['txt1'] ?? null; 
		$s1 = $apiParams['strict'] ?? 0; 
		$c2 = $apiParams['col2'] ?? null; 
		$t2 = $apiParams['txt2'] ?? null; 
		$r = $apiParams['rows'];
		$p = $apiParams['page'];
					
		$data = FxEntidades::GetPagedWithOptionalFilter($e, $c1, $t1, $s1, $c2, $t2, $r, $p);
		
		if($data)
			return $response->withJson($data, 200); 
		else
			return $response->withJson(false, 400);  
	} 

	public static function GetIngresosCaja($request, $response, $args) {

        $params = $request->getQueryParams();

        $res = FxEntidades::GetIngresosCaja($params['fechaDesde'],  $params['fechaHasta']);

        if(sizeof($res) > 0)
            return $response->withJson([
                'ok'    => true,
                'data'  => $res
            ], 200);

        else
        return $response->withJson([
            'ok'    => false,
            'msg'   => 'No existen datos'
        ], 400);
        
    } 

	
}