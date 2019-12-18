<?php

require_once __DIR__ . '/../Usuarios.php';
require_once __DIR__ . '/../AutentificadorJWT.php';

class UsuarioApi
{

    public static function Login($request, $response, $args)
    {
        $datosRecibidos = $request->getParsedBody();
        $usuario = $datosRecibidos['usuario'];
        $password = $datosRecibidos['password'];

        $unUsuario = new Usuarios();
        $unUsuario->usuario = $usuario;
        $unUsuario->password = $password;

        $usuarioBuscado = Usuarios::TraerUno($unUsuario);

        if($usuarioBuscado != false){

            $token = AutentificadorJWT::CrearToken($usuarioBuscado);
            return $response->withJson([
                'ok'    => true,
                'token' => $token
            ], 200);
        
        } else
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'Usuario inexistente'
            ], 404);
        
    } 
}
