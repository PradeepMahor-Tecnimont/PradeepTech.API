using Core.Entities;
using Infrastructure.Config;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data
{
    public class StoreContext(DbContextOptions options) : DbContext(options)
    {
        public DbSet<Product> Products { get; set; }
        public DbSet<EntProduct> EntProducts { get; set; }
        public DbSet<UserCustomer> UserCustomers { get; set; }
        public DbSet<UsersClient> UsersClients { get; set; }
        public DbSet<CustomerProductProfile> CustomerProductProfiles { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(ProductConfiguration).Assembly);
        }
    }
}