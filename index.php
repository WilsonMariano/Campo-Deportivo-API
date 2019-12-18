<?php

    use \Psr\Http\Message\ServerRequestInterface as Request;
    use \Psr\Http\Message\ResponseInterface as Response;

    require_once 'composer/vendor/autoload.php';
    require_once 'clases/AccesoDatos.php';
    require_once 'clases/middlewares/MWAuth.php';
    require_once 'clases/apis/UsuarioApi.php';
    require_once 'clases/apis/SocioApi.php';
    require_once 'clases/apis/GenericApi.php';
   
    $config['displayErrorDetails'] = true;
    $config['addContentLengthHeader'] = false;

    $app = new \Slim\App(["settings" => $config]);


    $app->add(function ($req, $res, $next){
		$response = $next($req, $res);
		return $response
			->withHeader('Access-Control-Allow-Origin', '*')
            ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
            ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
	});

	$app->group('/usuarios', function () {

        $this->post('/login[/]', \UsuarioApi::class . ':Login');
    });

    $app->group('/socios', function () {

        $this->post('/insert[/]', \SocioApi::class . ':Insert')->add(\MWAuth::class . ':VerificarUsuario');
        $this->put('/update[/]', \SocioApi::class . ':update');
    });

    $app->group('/generic', function () {

        $this->post('/insert[/]', \GenericApi::class . ':Insert');
        $this->put('/update[/]', \GenericApi::class . ':UpdateOne');
        $this->get('/all[/]', \GenericApi::class . ':GetAll');  
        $this->get('/one/{id}', \GenericApi::class . ':GetOne');   
    });

	$app->run();