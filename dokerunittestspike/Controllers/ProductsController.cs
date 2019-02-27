using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using dockerunittestspike.dto;
using dockerunittestspike.services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace dokerunittestspike.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private readonly IProductsService _productsService;

        public ProductsController(IProductsService productsService)
        {
            this._productsService = productsService;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var result = await this._productsService.GetAll();
            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var result = await this._productsService.GetAll();
            return Ok(result);
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] ProductDto product)
        {
            var result = await this._productsService.Create(product);
            return Ok(result);
        }
    }
}