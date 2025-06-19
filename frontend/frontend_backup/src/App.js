// frontend/src/App.js
import React, { useState } from "react";

export default function App() {
  const [form, setForm] = useState({ name: "", email: "", datetime: "" });
  const [status, setStatus] = useState("");

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const res = await fetch("/api/book", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form),
      });
      const data = await res.json();
      if (res.ok) {
        setStatus("✅ Booking successful!");
      } else {
        setStatus(`❌ Error: ${data.error}`);
      }
    } catch (err) {
      setStatus("❌ Failed to connect to server.");
    }
  };

  return (
    <div style={{ padding: "2rem", fontFamily: "'Poppins', sans-serif", background: "#f4f6f8", minHeight: "100vh" }}>
      <h1 style={{ color: "#1e88e5" }}>🔐 SecureMyWeb</h1>
      <form onSubmit={handleSubmit} style={{ background: "#fff", padding: "1.5rem", borderRadius: "12px", maxWidth: "500px", margin: "2rem auto", boxShadow: "0 2px 10px rgba(0,0,0,0.1)" }}>
        <input name="name" placeholder="Your Name" required onChange={handleChange} style={inputStyle} /><br />
        <input name="email" placeholder="Email" type="email" required onChange={handleChange} style={inputStyle} /><br />
        <input name="datetime" type="datetime-local" required onChange={handleChange} style={inputStyle} /><br />
        <button type="submit" style={{ ...inputStyle, background: "#43a047", color: "white", cursor: "pointer" }}>Book Now</button>
        {status && <p style={{ marginTop: "1rem", fontWeight: "bold" }}>{status}</p>}
      </form>
    </div>
  );
}

const inputStyle = {
  padding: "0.75rem",
  margin: "0.5rem 0",
  width: "100%",
  borderRadius: "8px",
  border: "1px solid #ccc"
};

