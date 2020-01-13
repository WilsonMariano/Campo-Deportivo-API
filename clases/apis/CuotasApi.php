<?php

require_once __DIR__ . '/../Cuotas.php';

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


}