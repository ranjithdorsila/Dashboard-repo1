using DevExpress.AspNetCore;
using DevExpress.DashboardAspNetCore;
using DevExpress.DashboardWeb;
using Microsoft.Extensions.FileProviders;
using dashboard;

var builder = WebApplication.CreateBuilder(args);

IFileProvider? fileProvider = builder.Environment.ContentRootFileProvider;
IConfiguration? configuration = builder.Configuration;

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages();

builder.Services.AddDevExpressControls();
builder.Services.AddScoped<DashboardConfigurator>((IServiceProvider serviceProvider) => {
    return DashboardUtils.CreateDashboardConfigurator(configuration, fileProvider);
});

var app = builder.Build();


// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseDevExpressControls();

app.UseRouting();

app.UseAuthorization();
app.MapRazorPages();

app.MapDashboardRoute("dashboardControl", "DefaultDashboard");

app.Run();