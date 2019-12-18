<?php

require_once __DIR__ . '/../Socios.php';
require_once __DIR__ . '/../_FxEntidades.php';

class SocioApi {

    public static function Insert($request, $response, $args) {
        $apiParamsBody = $request->getParsedBody();

        // Obtengo instancia de clase correspondiente.
        $objEntidad = FxEntidades::GetObjEntidad('Socios', $apiParamsBody);

        $res = Socios::Insertar($objEntidad);

        if($res == 2) {
            return $response->withJson([
                'ok'    => true,
                'msg'   => "Socio insertado con éxito"
            ], 200);
        
        } else
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'Se produjo un error'
            ], 500);
    } 

    public static function Update($request, $response, $args) {
        $apiParamsBody = $request->getParsedBody();

        // Obtengo instancia de clase correspondiente.
        $objEntidad = FxEntidades::GetObjEntidad('Socios', $apiParamsBody);

        $res = Socios::Update($objEntidad);

        if($res != 0) {
            return $response->withJson([
                'ok'    => true,
                'msg'   => "Socio actualizado con éxito"
            ], 200);
        
        } else
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'Se produjo un error'
            ], 500);
    } 

}