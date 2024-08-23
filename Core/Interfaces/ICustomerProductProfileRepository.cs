using Core.Entities;

namespace Core.Interfaces
{
    public interface ICustomerProductProfileRepository
    {
        Task<IReadOnlyList<CustomerProductProfile>> GetCustomerProductProfilesAsync();

        Task<CustomerProductProfile?> GetCustomerProductProfileByIdAsync(int id);

        void AddCustomerProductProfileAsync(CustomerProductProfile CustomerProductProfile);

        void UpdateCustomerProductProfileAsync(CustomerProductProfile CustomerProductProfile);

        void DeleteCustomerProductProfileAsync(CustomerProductProfile CustomerProductProfile);

        bool CustomerProductProfileExists(int id);

        Task<bool> SaveChangesAsync();
    }
}