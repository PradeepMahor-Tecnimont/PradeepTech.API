using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpVaccinationOfficeConfiguration : IEntityTypeConfiguration<SwpVaccinationOffice>
    {
        public void Configure(EntityTypeBuilder<SwpVaccinationOffice> entity)
        {
            entity.HasKey(e => e.Empno)
                .HasName("SWP_VACCINATION_OFFICE_PK");

            entity.Property(e => e.Empno)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.AttendingVaccination).IsUnicode(false);

            entity.Property(e => e.CowinRegtrd).IsUnicode(false);

            entity.Property(e => e.Mobile).IsUnicode(false);

            entity.Property(e => e.NotAttendingReason).IsUnicode(false);

            entity.Property(e => e.OfficeBus).IsUnicode(false);

            entity.Property(e => e.OfficeBusRoute).IsUnicode(false);

            entity.Property(e => e.JabNumber).IsUnicode(false);
        }
    }
}