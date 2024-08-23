using Core.Entities;

namespace Core.Interfaces
{
    public interface IUserCustomerRepository
    {
        Task<IReadOnlyList<UserCustomer>> GetUserCustomersAsync();

        Task<UserCustomer?> GetUserCustomerByIdAsync(int id);

        void AddUserCustomerAsync(UserCustomer UserCustomer);

        void UpdateUserCustomerAsync(UserCustomer UserCustomer);

        void DeleteUserCustomerAsync(UserCustomer UserCustomer);

        bool UserCustomerExists(int id);

        Task<bool> SaveChangesAsync();
    }
}