@Serializable
data class Name(val: firstName: String, val lastName: String)

@Serializable
data class User(val id: String, val email: String, val name: Name, createdAt: LocalDateTime)

@Serializable
data class Post(val id: String, val author: User, val content: String, createdAt: LocalDateTime)
@Serializable
data class Comment(val id: String, val post: Post, val author: User, content: String, createdAt: LocalDateTime)