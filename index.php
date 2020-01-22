<?php

    use \Psr\Http\Message\ServerRequestInterface as Request;
    use \Psr\Http\Message\ResponseInterface as Response;

    require_once 'composer/vendor/autoload.php';
    require_once 'clases/AccesoDatos.php';
    require_once 'clases/middlewares/MWAuth.php';
    require_once 'clases/apis/UsuarioApi.php';
    require_once 'clases/apis/SocioApi.php';
    require_once 'clases/apis/GenericApi.php';
    require_once 'clases/apis/DiccionarioApi.php';
    require_once 'clases/apis/ValoresApi.php';
    require_once 'clases/apis/BonosApi.php';
    require_once 'clases/apis/CuotasApi.php';
   
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

        $this->post('/insert[/]',                                       \SocioApi::class . ':Insert');
        $this->post('/insertFamilia[/]',                                \SocioApi::class . ':InsertFamilia');
        $this->post('/register[/]',                                     \SocioApi::class . ':RegisterSocio');
        $this->put('/update[/]',                                        \SocioApi::class . ':Update');
        $this->get('/getOne/{idSocio}',                                 \SocioApi::class . ':GetOne');
        $this->get('/getTitular/{idSocio}',                             \SocioApi::class . ':GetTitularByIdSocio');
        $this->get('/getGroupFamily/{idSocioTitular}/{codParentesco}',  \SocioApi::class . ':GetGroupFamily');
    });

    $app->group('/generic', function () {

        $this->post('/insert[/]', \GenericApi::class . ':Insert');
        $this->put('/update[/]', \GenericApi::class . ':UpdateOne');
        $this->get('/all[/]', \GenericApi::class . ':GetAll');  
        $this->get('/one/{id}', \GenericApi::class . ':GetOne');   
        $this->get('/paged[/]', \GenericApi::class . ':GetPagedWithOptionalFilter');
    });

    $app->group('/diccionario', function () {

        $this->get('/getWithKeys[/]', \DiccionarioApi::class . ':GetWithKeys');
    });

    $app->group('/valores', function () {

        $this->get('/getValor[/]', \ValoresApi::class . ':GetValor');
    });

    $app->group('/bonos', function () {

        $this->get('/getBetweenDate[/]',    \BonosApi::class . ':GetBetweenDate');
        $this->post('/insert[/]',           \BonosApi::class . ':Insert');
        $this->put('/cancelBono/{id}',     \BonosApi::class . ':CancelBono');

    });

    $app->group('/cuotas', function () {

        $this->post('/insert[/]', \CuotasApi::class . ':Insert');
        $this->get('/getCuotas/{idSocio}', \CuotasApi::class . ':getBySocio');
    });

	$app->run();