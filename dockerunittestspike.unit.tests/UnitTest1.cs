using System;
using System.Collections.Generic;
using dockerunittestspike.dataaccess;
using dockerunittestspike.domain;
using dockerunittestspike.services;
using Moq;
using Xunit;

namespace dockerunittestspike.unit.tests
{
    public class UnitTest1
    {
        private Mock<IProductsRepository> mockProductRepository;
        private string shouldFailTest = Environment.GetEnvironmentVariable("FAIL_TEST");

        public UnitTest1()
        {
            this.mockProductRepository = new Mock<IProductsRepository>();
        }

        [Fact]
        public void Given_ProductId_ProductServices_Returns_Product()
        {
            this.mockProductRepository.Setup(x => x.Products).Returns(new List<Product>()
                {new Product() {Id = 1, Name = "product1"}, new Product() {Id = 1, Name = "product1"}});

            var productService = new ProductsService(this.mockProductRepository.Object);

            var actualResult = productService.GetById(1).Result;
            Assert.True(actualResult.Id == 1);
        }

        [Fact]
        public void Given_ExistingProducts_ProductServices_Returns_All_Products()
        {
            this.mockProductRepository.Setup(x => x.Products).Returns(new List<Product>()
                {new Product() {Id = 1, Name = "product1"}, new Product() {Id = 1, Name = "product1"}});

            var productService = new ProductsService(this.mockProductRepository.Object);

            var actualResult = productService.GetAll().Result;
            Assert.True(actualResult.Count == 2);
        }

        [Fact]
        public void Externally_Controlled_Test()
        {
            if (!string.IsNullOrEmpty(shouldFailTest))
            {
                Assert.False(false, "Test failed because FAIL_TEST environment variable is set");
            }
            else
            {
                Assert.True(true);
            }
        }
    }
}
