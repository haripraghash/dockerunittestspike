using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using dockerunittestspike.dataaccess;
using dockerunittestspike.domain;
using dockerunittestspike.dto;

namespace dockerunittestspike.services
{
    public interface IProductsService
    {
        Task<ProductDto> GetById(int id);

        Task<List<ProductDto>> GetAll();

        Task<ProductDto> Create(ProductDto product);
    }

    public class ProductsService : IProductsService
    {
        private readonly IProductsRepository _productsRepository;

        public ProductsService(IProductsRepository productsRepository)
        {
            this._productsRepository = productsRepository;
        }

        public async Task<ProductDto> GetById(int id)
        {
            var result = await Task.FromResult(this._productsRepository.Products.FirstOrDefault(x => x.Id == id));
            return new ProductDto()
            {
                Id = result.Id,
                Name = result.Name
            };
        }

        public async Task<List<ProductDto>> GetAll()
        {
            var results = await Task.FromResult(this._productsRepository.Products);
            return results.Select(x => new ProductDto() { Id = x.Id, Name = x.Name }).ToList();
        }

        public async Task<ProductDto> Create(ProductDto product)
        {
            var result = await this._productsRepository.Add(new Product() { Name = product.Name });
            return new ProductDto()
            {
                Id = result.Id,
                Name = result.Name
            };
        }
    }
}
