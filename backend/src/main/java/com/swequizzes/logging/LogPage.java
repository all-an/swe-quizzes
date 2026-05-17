package com.swequizzes.logging;

import java.util.List;

public record LogPage<T>(List<T> items, int page, int pageSize, int totalPages, long totalElements) {}
