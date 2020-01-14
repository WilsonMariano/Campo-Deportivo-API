<?php

require_once __DIR__ . '/../Cuotas.php';
require_once __DIR__ . '/../_FxEntidades.php';

class CuotasApi {

    public static function getBySocioTitular($request, $response, $args) {

        $idSocioTitular = json_decode($args['idSocioTitular']);

        $res = Cuotas::GetBySocioTitular($idSocioTitular);

        if(sizeof($res) > 0)
            return $response->withJson([
                'ok'    => true,
                'data'  => $res
            ], 200);

        else
        return $response->withJson([
            'ok'    => false,
            'msg'   => 'No existen socios con ese id'
        ], 400);
        
    } 

    public static function Insert($request, $response) {

        $apiParams = $request->getParsedBody();	

        $obj = new Cuotas($apiParams);

        $res = FxEntidades::InsertOne($obj);
        
        if(is_numeric($res)) {

            $res2 = FxEntidades::GetOne($res, 'vwCuotas');

            if($res2 != false) 
                return $response->withJson([
                    'ok'    => true,
                    'data'  => $res2
                ], 200);

            else
                return $response->withJson([
                    'ok'    => false,
                    'msg'    => "Error al recuperar la cuota"
                ], 500);

        } else {

            return $response->withJson([
                'ok'    => false,
                'msg'    => "Error al insertar la cuota"
            ], 500);
        }

    }

}