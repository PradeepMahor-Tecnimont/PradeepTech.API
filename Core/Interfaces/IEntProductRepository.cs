using Core.Entities;

namespace Core.Interfaces
{
    public interface IEntProductRepository
    {
        Task<IReadOnlyList<EntProduct>> GetEntProductsAsync();

        Task<EntProduct?> GetEntProductByIdAsync(int id);

        void AddEntProductAsync(EntProduct EntProduct);

        void UpdateEntProductAsync(EntProduct EntProduct);

        void DeleteEntProductAsync(EntProduct EntProduct);

        bool EntProductExists(int id);

        Task<bool> SaveChangesAsync();
    }
}