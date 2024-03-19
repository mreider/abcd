using Microsoft.AspNetCore.Mvc;
using System.Net.Http;
using System.Threading.Tasks;

namespace ServiceB.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ServiceBController : ControllerBase
    {
        private readonly HttpClient _httpClient;

        public ServiceBController(IHttpClientFactory httpClientFactory)
        {
            _httpClient = httpClientFactory.CreateClient();
        }

        [HttpGet]
        [Route("call")]
        public async Task<string> CallService()
        {
            var response = await _httpClient.GetStringAsync("http://servicec:8082");
            return "Called from .NET Service B -> " + response;
        }
    }
}
