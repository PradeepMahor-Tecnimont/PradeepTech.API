using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpVuVaccineOffBatch2RegnConfiguration : IEntityTypeConfiguration<SwpVuVaccineOffBatch2Regn>
    {
        public void Configure(EntityTypeBuilder<SwpVuVaccineOffBatch2Regn> entity)
        {
            entity.ToView("SWP_VU_OFF_VACCINE_BATCH2_REGN");

            entity.Property(e => e.EmployeeName).IsUnicode(false);

            entity.Property(e => e.Empno)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.FamilyMemberName).IsUnicode(false);

            entity.Property(e => e.JabNum).IsUnicode(false);

            entity.Property(e => e.Relation).IsUnicode(false);
        }
    }
}