using Core.Entities;
using Core.Interfaces;
using Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Repository
{
    public class EntProductRepository(StoreContext context) : IEntProductRepository
    {
        public void AddEntProductAsync(EntProduct EntProduct)
        {
            context.EntProducts.Add(EntProduct);
        }

        public void DeleteEntProductAsync(EntProduct EntProduct)
        {
            context.EntProducts.Remove(EntProduct);
        }

        public async Task<EntProduct?> GetEntProductByIdAsync(int id)
        {
            return await context.EntProducts.FindAsync(id);
        }

        public async Task<IReadOnlyList<EntProduct>> GetEntProductsAsync()
        {
            return await context.EntProducts.ToListAsync();
        }

        public bool EntProductExists(int id)
        {
            return context.EntProducts.Any(p => p.Id == id);
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await context.SaveChangesAsync() > 0;
        }

        public void UpdateEntProductAsync(EntProduct EntProduct)
        {
            context.Entry(EntProduct).State = EntityState.Modified;
        }
    }
}