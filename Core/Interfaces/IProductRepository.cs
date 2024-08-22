using Core.Entities;

namespace Core.Interfaces
{
    public interface IProductRepository
    {
        Task<IReadOnlyList<Product>> GetProductsAsync();

        Task<Product?> GetProductByIdAsync(int id);

        void AddProductAsync(Product product);

        void UpdateProductAsync(Product product);

        void DeleteProductAsync(Product product);

        bool ProductExists(int id);

        Task<bool> SaveChangesAsync();
    }
}