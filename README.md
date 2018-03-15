# t12n

This is a proof-of-concept implementation of an alternate representation for 2D transformations. Instead of representing transformations as a matrix, t12n represents transformations as a list of transform operations. Each operation is easy to think about and manipulate independently.

Preliminary testing indicates a decrease in round-off error and an increase in transformation inversion performance. For more information have a look at the [blog post](https://a-coding.com/representing-transformations/).

---

## License

t12n is available under the MIT License. See the LICENSE file for more info.
