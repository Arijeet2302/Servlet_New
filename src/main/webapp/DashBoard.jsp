<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parcel Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }

        .navbar {
            background-color: #343a40;
            color: white;
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar ul {
            display: flex;
            gap: 20px;
            padding: 0;
            width: 100%;
            justify-content: space-between;
            align-items: center;
        }

        .navbar ul li {
            list-style: none;
            font-size: 16px;
        }

        .navbar ul li a {
            text-decoration: none;
            color: white;
            font-weight: bold;
        }

        .navbar ul li a:hover {
            color: #ffc107;
        }

        .container {
            width: 90%;
            margin: 20px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .search-section {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .search-section input {
            width: 300px;
            padding: 8px;
            margin-right: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .search-section button {
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .search-section button:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table th,
        table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }

        .status {
            font-weight: bold;
        }

        button {
            padding: 6px 12px;
            margin: 2px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .detailsButton {
            background-color: #28a745;
            color: white;
        }

        .statusButton {
            background-color: #ffc107;
            color: black;
        }

        button:hover {
            opacity: 0.9;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 50%;
            text-align: center;
            border-radius: 8px;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
        }
    </style>
</head>

<body>
    <!-- Navbar -->
    <header>
        <nav class="navbar">
            <ul>
                <li><a href="home.html">Home</a></li>
                <li class="welcome-messege" id="welcomeMessege">Welcome, <span id="username">Customer</span></li>
                <li><a href="logout">Logout</a></li>
            </ul>
        </nav>
    </header>

    <div class="container">
        <h1>Parcel Tracking</h1>
        <div class="search-section">
            <input type="text" id="searchBookingId" placeholder="Enter Booking ID">
            <button id="searchButton">Search</button>
        </div>
        <table id="parcelTable">
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Full Name</th>
                    <th>Address</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>12345</td>
                    <td>John Doe</td>
                    <td>123 Street, NY</td>
                    <td><span class="status">In Transit</span></td>
                    <td>
                        <button class="detailsButton">Details</button>
                        <button class="statusButton">Change Status</button>
                    </td>
                </tr>
                <tr>
                    <td>67890</td>
                    <td>Alice Brown</td>
                    <td>789 Boulevard, SF</td>
                    <td><span class="status">Delivered</span></td>
                    <td>
                        <button class="detailsButton">Details</button>
                        <button class="statusButton">Change Status</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- Modal -->
    <div id="myModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2 id="modalTitle">Details</h2>
            <div id="modalContent"></div>
            <div id="statusChangeSection" style="display: none;">
                <label for="statusSelect">Select Status:</label>
                <select id="statusSelect">
                    <option value="Picked up">Picked up</option>
                    <option value="In Transit">In Transit</option>
                    <option value="Delivered">Delivered</option>
                    <option value="Returned">Returned</option>
                </select>
                <button id="updateStatusButton">Update Status</button>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const searchButton = document.getElementById("searchButton");
            const searchBookingId = document.getElementById("searchBookingId");
            const parcelTable = document.getElementById("parcelTable");
            const modal = document.getElementById('myModal');
            const closeModal = document.querySelector(".close");
            const modalTitle = document.getElementById("modalTitle");
            const modalContent = document.getElementById("modalContent");
            const statusChangeSection = document.getElementById("statusChangeSection");
            const updateStatusButton = document.getElementById("updateStatusButton");
            let selectedRow = null;

            // Search functionality
            searchButton.addEventListener("click", () => {
                const searchValue = searchBookingId.value.trim();
                const rows = parcelTable.querySelectorAll("tbody tr");
                let found = false;

                rows.forEach(row => {
                    if (row.cells[0].innerText === searchValue || searchValue === "") {
                        row.style.display = "";
                        found = true;
                    } else {
                        row.style.display = "none";
                    }
                });

                if (!found && searchValue !== "") {
                    alert("No records found for the given Booking ID.");
                }
            });

            // Handle table button clicks
            parcelTable.addEventListener("click", (event) => {
                const target = event.target;

                if (target.classList.contains("detailsButton")) {
                    const row = target.closest("tr");
                    const bookingId = row.cells[0].innerText;
                    const fullName = row.cells[1].innerText;
                    const address = row.cells[2].innerText;
                    const status = row.cells[3].innerText;

                    modalTitle.innerText = "Details";
                    modalContent.innerHTML = `
                        <p><strong>Booking ID:</strong> ${bookingId}</p>
                        <p><strong>Full Name:</strong> ${fullName}</p>
                        <p><strong>Address:</strong> ${address}</p>
                        <p><strong>Status:</strong> ${status}</p>`;
                    statusChangeSection.style.display = "none";
                    modal.style.display = "block";
                }

                if (target.classList.contains("statusButton")) {
                    selectedRow = target.closest("tr");
                    modalTitle.innerText = "Change Status";
                    modalContent.innerHTML = `
                        <p><strong>Booking ID:</strong> ${selectedRow.cells[0].innerText}</p>`;
                    statusChangeSection.style.display = "block";
                    modal.style.display = "block";
                }
            });

            // Close modal
            closeModal.addEventListener("click", () => {
                modal.style.display = "none";
            });

            // Update status
            updateStatusButton.addEventListener("click", () => {
                if (selectedRow) {
                    const newStatus = document.getElementById("statusSelect").value;
                    selectedRow.querySelector(".status").innerText = newStatus;
                    modal.style.display = "none"; // Close the modal
                    alert(`Status updated to "${newStatus}" for Booking ID: ${selectedRow.cells[0].innerText}`);
                }
            });

            // Close the modal when clicking outside the modal content
            window.addEventListener("click", (event) => {
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            });
        });
    </script>
</body>

</html>
               