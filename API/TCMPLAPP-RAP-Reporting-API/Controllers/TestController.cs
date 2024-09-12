
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData.Query;
using Microsoft.EntityFrameworkCore;
using RapReportingApi.RAPEntityModels;
using System.Collections.Generic;
using System.Threading.Tasks;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace RapReportingApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Roslynator", "RCS1044:Remove original exception from throw statement.", Justification = "<Pending>")]
    public class TestController : ControllerBase
    {
        // GET: /<controller>/
        //public IActionResult Index()
        //{
        //    return View();
        //}
        private readonly RAPDbContext _dbContext;

        public TestController(RAPDbContext dbContext)
        {
            _dbContext = dbContext;
        }

    }
}