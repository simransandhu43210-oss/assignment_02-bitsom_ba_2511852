## Database Recommendation

For a healthcare startup building a patient management system, *MySQL* would be the most suitable choice as the primary database.

Healthcare environments handle some of the most sensitive data imaginable patient records, medical histories, prescriptions, and billing information. In such a domain, consistency and integrity are non-negotiable. MySQL is built around *ACID principles* Atomicity, Consistency, Isolation, and Durability ensuring every transaction is reliable and data remains accurate even during system failures. When updating a patient's treatment plan or processing a billing entry, the operation must either complete fully or not happen at all. Partial updates are simply not acceptable.

NoSQL databases like MongoDB follow the *BASE model* Basically Available, Soft State, and Eventual Consistency. While this offers greater flexibility and scalability, it permits temporary data inconsistencies. For most applications, this trade-off is reasonable. In healthcare, however, inconsistent or outdated patient records can lead to serious real-world harm, making eventual consistency an unacceptable risk.

The *CAP theorem* further supports this choice. Since distributed systems can only guarantee two of three properties Consistency, Availability, and Partition Tolerance simultaneously, healthcare systems must prioritize consistency over availability. If a network issue arises, it is far better to restrict access than to serve incorrect patient data.

That said, if the system were to include a *fraud detection module*, a hybrid architecture would make more sense. Fraud detection involves processing large volumes of streaming and semi-structured data, where NoSQL databases excel. In that case, MongoDB could operate alongside MySQL managing analytics and real-time detection, while MySQL remains the authoritative source for all structured patient and billing records.