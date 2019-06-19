import React from 'react';

export function ErrorMessage(name) {
  return (
    <div className="pure-u-1 no-results-error-message">
      <h3>We couldn't find anyone named {name}</h3>
      <br/>
      <p>Search tips:</p>
      <ul>
        <li>
          Check the spelling
        </li>
        <li>
          Try using a first name or last name
        </li>
        <li>
          Search on all customers by leaving the field blank
        </li>
      </ul>
    </div> 
  );
}