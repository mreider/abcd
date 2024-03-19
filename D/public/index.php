<?php

use OpenTelemetry\API\Globals;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;

require __DIR__ . '/../vendor/autoload.php';

$tracer = Globals::tracerProvider()->getTracer('demo');

$app = AppFactory::create();

// Define a simple route that creates a span and returns a text message.
$app->get('/rolldice', function (Request $request, Response $response) use ($tracer) {
    $span = $tracer->spanBuilder('manual-span')->startSpan();
    
    $response->getBody()->write("Returning a simple text response.");
    
    $span->addEvent('Returned text response')->end();
    return $response;
});

$app->run();
