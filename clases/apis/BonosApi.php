<?php

require_once __DIR__ . '/../_FxEntidades.php';

class BonosApi {

    public static function Insert($request, $response) {

        $apiParams = $request->getParsedBody();	

        $obj = new Bonos($apiParams);

        // var_dump($obj);

        $res = FxEntidades::InsertOne($obj);

        if(is_numeric($res)) {

            $res2 = FxEntidades::GetOne($res, 'vwBonos');

            if($res2 != false) 
                return $response->withJson([
                    'ok'    => true,
                    'data'  => $res2
                ], 200);

            else
                return $response->withJson([
                    'ok'    => false,
                    'msg'    => "Error al recuperar el bono"
                ], 500);

        } else {

            return $response->withJson([
                'ok'    => false,
                'msg'    => "Error al insertar el bono"
            ], 500);
        }
    }

    public static function GetBetweenDate($request, $response) {

        $params = $request->getQueryParams();

        $res = Bonos::GetBetweenDate($params['fechaDesde'], $params['fechaHasta']);

        if(sizeof($res) != 0)
            return $response->withJson([
                'ok'    => true,
                'data'  => $res
            ], 200);
        
        else
            return $response->withJson([
                'ok'    => false,
                'msg'  => "No se encontraron bonos"
            ], 400);
    }
}