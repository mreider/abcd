const express = require('express');
const axios = require('axios');
const { trace, context } = require('@opentelemetry/api');
const { NodeTracerProvider } = require('@opentelemetry/node');
const { ExpressInstrumentation } = require('@opentelemetry/instrumentation-express');
const { HttpInstrumentation } = require('@opentelemetry/instrumentation-http');
const { SimpleSpanProcessor } = require('@opentelemetry/tracing');
const { ConsoleSpanExporter } = require('@opentelemetry/tracing');

const provider = new NodeTracerProvider();

const consoleExporter = new ConsoleSpanExporter();
provider.addSpanProcessor(new SimpleSpanProcessor(consoleExporter));

provider.register();

// Initialize Express instrumentation
const expressInstrumentation = new ExpressInstrumentation();
expressInstrumentation.setTracerProvider(provider);

const app = express();
const port = 8082;

app.get('/', async (req, res) => {
  const span = trace.getTracer('default').startSpan('ServiceC-call');
  context.with(trace.setSpan(context.active(), span), async () => {
    try {
      const response = await axios.get('http://serviced:8083/');
      res.send(`Node Service C -> ${response.data}`);
    } catch (error) {
      console.error(error);
      res.status(500).send('Error calling Service D');
    } finally {
      span.end();
    }
  });
});

app.listen(port, () => {
  console.log(`Service C listening at http://localhost:${port}`);
});
