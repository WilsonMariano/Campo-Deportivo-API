<?php

require_once __DIR__ . "/../AutentificadorJWT.php";

class MWAuth {

  public function VerificarUsuario($request, $response, $next) {
	 
      $token = $request->getHeaders()['HTTP_AUTHORIZATION'][0];

      try {

        AutentificadorJWT::VerificarToken($token);
      }
      catch(Exception $ex) {

        return $response->withJson($ex->getMessage(), 500);
      }

      return $next($request, $response);
	}    
}