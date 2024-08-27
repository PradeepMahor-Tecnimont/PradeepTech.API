﻿namespace API.RequestHelpers
{
    public class Pagination<T>
            (int pageIndex,
             int pageSize,
             int count,
             IReadOnlyCollection<T> data)
    {
        public int PageIndex { get; set; } = pageIndex;
        public int PageSize { get; set; } = pageSize;
        public int Count { get; set; } = count;
        public IReadOnlyCollection<T> Data { get; set; } = data;
    }
}