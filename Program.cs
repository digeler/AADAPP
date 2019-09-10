using System.Net;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Logging;

namespace aad
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
            //.UseUrls("http://0.0.0.0:5000","https://0.0.0.0:5001")
             .ConfigureKestrel((context, options) =>
        {
            options.Listen(IPAddress.Any,5000);
            options.Listen(IPAddress.Any,5001,listenOptions => 
            {
                listenOptions.UseHttps("certificate.pfx","dinor111");

            });
            

        })
         .ConfigureLogging((hostingContext, logging) =>
        {
            // Requires `using Microsoft.Extensions.Logging;`
            logging.AddConfiguration(hostingContext.Configuration.GetSection("Logging"));
            
            logging.AddConsole();
            logging.AddDebug();
            logging.AddEventSourceLogger();
        })
                .UseStartup<Startup>();
               
                  
                
    }
}
