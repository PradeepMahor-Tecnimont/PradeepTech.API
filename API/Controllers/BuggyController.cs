using API.DTOs;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace API.Controllers
{
    public class BuggyController : BaseApiController
    {
        // GET: api/<BuggyController>

        [HttpGet("Unauthorized")]
        public IActionResult GetUnauthorized()
        {
            return Unauthorized();
        }

        [HttpGet("BadRequest")]
        public IActionResult GetBadRequest()
        {
            return BadRequest("Not a good request");
        }

        [HttpGet("NotFound")]
        public IActionResult GetNotFound()
        {
            return NotFound();
        }

        [HttpGet("InternalError")]
        public IActionResult GetInternalError()
        {
            throw new Exception("This is a test Exception");
        }

        [HttpPost("ValidationError")]
        public IActionResult GetValidationError(CreateProductDto Product)
        {
            return Ok();
        }
    }
}