<?php

require_once __DIR__ . '/../Diccionario.php';

class DiccionarioApi
{

    public static function getWithKeys($request, $response, $args) {
        $apiParams = $request->getQueryParams();
        $key = $apiParams['key'];

        $res = Diccionario::getWithKeys($key);

        if(sizeof($res) > 0){

            return $response->withJson([
                'ok'    => true,
                'data'    => $res
            ], 200);
        
        } else
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'No se encontraron resultados'
            ], 404);
        
    } 
}
