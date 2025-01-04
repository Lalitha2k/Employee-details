/* const admin = require('firebase-admin');
const serviceAccount = require('./adminsdk_key.json');  // Ensure this path is correct

const employeesData = require('./employees_data.json'); 

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Add employees to Firestore
async function addEmployees() {
  const employeesRef = db.collection('Employees');

  for (const employee of employeesData) {
    await employeesRef.add({
      employeeId: employee.employeeId,
      name: employee.name,
      joiningDate: employee.joiningDate,
      isActive: employee.isActive
    });
  }

  console.log('Data imported successfully');
}

addEmployees().catch(console.error);
*/

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Initialize Firebase Admin SDK
const serviceAccount = require('./adminsdk_key.json'); 

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://your-project-id.firebaseio.com' 
});

// Read the employees data 
const employeesData = require('./employees_data.json'); 


const db = admin.firestore();

// addding employees to Firestore
async function addEmployees() {
    const employees = employeesData.employees;  //  'employees' object
    
    // Convert the employees object into an array of employee values
    const employeeArray = Object.values(employees);

    // Iterating over each employee
    for (const employee of employeeArray) {
        try {
            const docRef = db.collection('employees').doc(employee.employeeId);  
            await docRef.set({
                employeeId: employee.employeeId,
                name: employee.name,
                joiningDate: employee.joiningDate,
                isActive: employee.isActive,
            });

            console.log(`Employee ${employee.name} added successfully.`);
        } catch (error) {
            console.error(`Error adding employee ${employee.name}:`, error);
        }
    }
}

// calling the function to add employees
addEmployees().then(() => {
    console.log('All employees processed.');
}).catch(error => {
    console.error('Error processing employees:', error);
});
