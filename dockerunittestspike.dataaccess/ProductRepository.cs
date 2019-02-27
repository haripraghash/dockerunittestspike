using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using dockerunittestspike.domain;

namespace dockerunittestspike.dataaccess
{
    public interface IProductsRepository
    {
        List<Product> Products { get; }

        Task<Product> Add(Product product);
    }

    public class ProductsRepository : IProductsRepository
    {
        private readonly List<Product> _products;
        private readonly Random _randomNumberGenerator;

        public ProductsRepository()
        {
            this._products = new List<Product>(50);
            this._randomNumberGenerator = new Random(1);
        }

        public List<Product> Products => this._products;

        public async Task<Product> Add(Product product)
        {
            product.Id = this._randomNumberGenerator.Next(1000);
            this._products.Add(product);
            await Task.CompletedTask;

            return product;
        }
    }
}
