using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HSE
{
    public class HSEQuizViewModel
    {
        public IEnumerable<HSEQuizDataTableList> Result { get; set; }
        public string QuizId { get; set; }
        public string QuestionId1 { get; set; }
        public string QuestionId2 { get; set; }
        public string QuestionId3 { get; set; }
        public string QuestionId4 { get; set; }
        public string QuestionId5 { get; set; }
        public string QuestionId6 { get; set; }
        public string QuestionId7 { get; set; }
        public string QuestionId8 { get; set; }
        public string QuestionId9 { get; set; }
        public string QuestionId10 { get; set; }
        public string AnswerId1 { get; set; }
        public string AnswerId2 { get; set; }
        public string AnswerId3 { get; set; }
        public string AnswerId4 { get; set; }
        public string AnswerId5 { get; set; }
        public string AnswerId6 { get; set; }
        public string AnswerId7 { get; set; }
        public string AnswerId8 { get; set; }
        public string AnswerId9 { get; set; }
        public string AnswerId10 { get; set; }
        public string QuestionName { get; set; }
        public string AnswerId { get; set; }
    }
}
