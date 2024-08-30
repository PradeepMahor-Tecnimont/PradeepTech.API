using API.Middleware;
using Core.Interfaces;
using Infrastructure.Data;
using Infrastructure.Repository;
using Microsoft.EntityFrameworkCore;

internal class Program
{
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.

        builder.Services.AddControllers();
        builder.Services.AddDbContext<StoreContext>(opt =>
        {
            opt.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
        }
        );

        builder.Services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));

        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();

        builder.Services.AddControllers();
        builder.Services.AddCors();
        var app = builder.Build();

        // Middleware
        app.UseMiddleware<ExceptionMiddleWare>();

        //app.UseCors(builder => builder
        //       .AllowAnyHeader()
        //       .AllowAnyMethod()
        //       .SetIsOriginAllowed((host) => true)
        //       .AllowCredentials()
        //   );

        app.UseCors(
                x => x.AllowAnyHeader()
                    .AllowAnyMethod()
                    .SetIsOriginAllowed((host) => true)
                    .WithOrigins("http://localhost:4200/", "https://localhost:4200/")
                    .AllowCredentials()
                    );

        // Configure the HTTP request pipeline.
        if (app.Environment.IsDevelopment())
        {
            app.UseSwagger();
            app.UseSwaggerUI();
        }
        app.UseStaticFiles();

        app.UseRouting();
#pragma warning disable ASP0014 // Suggest using top level route registrations
        app.UseEndpoints(endpoints =>
        {
            endpoints.MapControllers();
        });
#pragma warning restore ASP0014 // Suggest using top level route registrations

        app.UseHttpsRedirection();

        //app.UseAuthorization();

        app.MapControllers();

        app.Run();
    }
}