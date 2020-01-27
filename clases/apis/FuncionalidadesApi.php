<?php

require_once __DIR__ . '/../Funcionalidades.php';

class FuncionalidadesApi
{

    public static function GetCodPrestacion($request, $response, $args) {

        $apiParams = $request->getQueryParams();

        $res = Funcionalidades::GetCodPrestacion($apiParams['codTipoSocio']);

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

    public static function GetFuncionalidad($request, $response, $args) {

        $apiParams = $request->getQueryParams();

        $res = Funcionalidades::GetFuncionalidad($apiParams['codTipoSocio'], $apiParams['codFuncionalidad']);

        if($res){

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