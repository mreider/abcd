package servicea;

import io.opentelemetry.api.GlobalOpenTelemetry;
import io.opentelemetry.api.trace.Span;
import io.opentelemetry.api.trace.Tracer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;
import javax.annotation.PostConstruct;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@RestController
public class ServiceAController {

    private final WebClient webClient = WebClient.create();
    private final Tracer tracer = GlobalOpenTelemetry.getTracer("serviceA");
    private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

    @PostConstruct
    public void startServiceCalls() {
        scheduler.scheduleAtFixedRate(this::callServices, 0, 5, TimeUnit.SECONDS);
    }

    @GetMapping("/call")
    public String callServices() {
        Span span = tracer.spanBuilder("ServiceA-call").startSpan();
        try {
            String response = webClient.get()
                                       .uri("http://serviceb:8081/")
                                       .retrieve()
                                       .bodyToMono(String.class)
                                       .block();  // Consider using subscribe() for non-blocking
            return "Java Service A -> " + response;
        } finally {
            span.end();
        }
    }
}
